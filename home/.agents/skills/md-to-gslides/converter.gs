/** @OnlyCurrentDoc */

function inspect() {
  const pres = SlidesApp.getActivePresentation();
  const slides = pres.getSlides();
  pres.getLayouts().forEach(layout => {
    const example = slides.findIndex(s => s.getLayout()?.getObjectId() === layout.getObjectId());
    console.log(JSON.stringify({
      id: layout.getObjectId(),
      name: layout.getLayoutName(),
      placeholders: placeholdersOf(layout).map(s => [
        String(s.getPlaceholderType()),
        ...[s.getLeft(), s.getTop(), s.getWidth(), s.getHeight()].map(Math.round),
      ]),
      example: example < 0 ? null : {
        slide: example + 1,
        texts: placeholdersOf(slides[example]).map(s => s.getText().asString().slice(0, 40)),
      },
    }));
  });
}

function build() {
  const pres = SlidesApp.getActivePresentation();
  const store = PropertiesService.getDocumentProperties();
  const built = store.getProperties();
  const oldSlides = pres.getSlides();

  const candidates = oldSlides.filter(s => s.getObjectId() in built);
  const reused = DECK.map(entry => {
    const i = candidates.findIndex(s => built[s.getObjectId()] === JSON.stringify(entry));
    return i < 0 ? null : candidates.splice(i, 1)[0];
  });

  // 手で足したスライドは、直前に残る生成済みスライドに付いていく。初回に残っているのはテンプレートの見本なので消す
  const manual = Object.keys(built).length ? oldSlides.filter(s => !(s.getObjectId() in built)) : [];
  const ownerOf = new Map();
  let owner = null;
  oldSlides.forEach(s => {
    if (reused.includes(s)) owner = s;
    else ownerOf.set(s, owner);
  });
  const followersOf = owner => manual.filter(s => ownerOf.get(s) === owner);

  const slides = DECK.map((entry, i) => reused[i] ?? create(pres, entry));
  const ordered = [...followersOf(null), ...slides.flatMap(s => [s, ...followersOf(s)])];
  const removed = oldSlides.filter(s => !ordered.includes(s));
  removed.forEach(s => s.remove());
  ordered.forEach((s, i) => s.move(i));
  store.setProperties(Object.fromEntries(slides.map((s, i) => [s.getObjectId(), JSON.stringify(DECK[i])])), true);
  const reusedCount = reused.filter(Boolean).length;
  console.log(`再利用 ${reusedCount} 枚 / 新規 ${DECK.length - reusedCount} 枚 / 削除 ${removed.length} 枚 / 手動 ${manual.length} 枚`);
}

function create(pres, { layout, texts }) {
  const slide = pres.appendSlide(pres.getLayouts().find(l => l.getObjectId() === layout));
  placeholdersOf(slide).forEach((s, i) => fill(s.getText(), texts[i]));
  return slide;
}

function placeholdersOf(page) {
  return page.getPlaceholders()
    .filter(p => p.getPageElementType() === SlidesApp.PageElementType.SHAPE)
    .map(p => p.asShape())
    .sort((a, b) => a.getTop() - b.getTop() || a.getLeft() - b.getLeft());
}

const MONOSPACE = 'Roboto Mono';

// md2html のコードの配色に揃える
const TOKEN_STYLES = {
  bold: style => style.setBold(true),
  italic: style => style.setItalic(true),
  ...Object.fromEntries(Object.entries({
    '#aa2266': ['keyword', 'atrule', 'function', 'important'],
    '#0088bb': ['number', 'boolean', 'constant', 'class-name', 'builtin', 'symbol'],
    '#223399': ['string', 'char', 'regex', 'attr-value', 'url', 'inserted'],
    '#99aa99': ['comment', 'prolog', 'doctype', 'cdata'],
    '#8866aa': ['tag', 'attr-name', 'property', 'selector', 'variable', 'title', 'deleted'],
  }).flatMap(([color, types]) => types.map(type => [type, style => style.setForegroundColor(color)]))),
};

function fill(text, markdown) {
  if (markdown == null) return;
  const lines = parse(markdown);
  text.setText(lines.map(line => line.text).join('\n'));
  // 後ろの段落から処理し、バッククォートを消しても前の段落の位置がずれないようにする
  const paragraphs = text.getParagraphs();
  lines.map((line, i) => [line, paragraphs[i].getRange()]).reverse().forEach(([line, range]) => {
    if (line.block) return;
    range.find('`[^`\n]+`').reverse().forEach(code => {
      code.getTextStyle().setFontFamily(MONOSPACE);
      code.clear(code.getLength() - 1, code.getLength());
      code.clear(0, 1);
    });
  });
  const blocks = lines.map(line => line.block);
  const ranges = text.getParagraphs().map(p => p.getRange());
  new Set(blocks.filter(Boolean)).forEach(block => {
    const [first, last] = [blocks.indexOf(block), blocks.lastIndexOf(block)];
    const range = text.getRange(ranges[first].getStartIndex(), ranges[last].getEndIndex());
    range.getTextStyle().setFontFamily(MONOSPACE);
    // プレースホルダの段落の間隔がコードの 1 行ごとに付くので、ブロックの中だけ詰める
    ranges.slice(first, last).forEach(paragraph => paragraph.getParagraphStyle().setSpaceBelow(0));
    highlight(range, block.lang);
  });
  // リストにすると行頭のタブが消えて後ろの段落の位置がずれるので、段落は毎回取り直す
  listRuns(lines).forEach(({ numbered, first, last }) => {
    const paragraphs = text.getParagraphs();
    text.getRange(paragraphs[first].getRange().getStartIndex(), paragraphs[last].getRange().getEndIndex())
      .getListStyle().applyListPreset(numbered ? SlidesApp.ListPreset.DIGIT_ALPHA_ROMAN : SlidesApp.ListPreset.DISC_CIRCLE_SQUARE);
  });
}

// 草案の行を、スライドに書く文字列とリストの記号に分ける。コードブロックの行は書かれたまま写し、所属するブロックを持たせる
function parse(markdown) {
  const lines = [];
  let block = null;
  markdown.split('\n').forEach(line => {
    const fence = line.match(/^(`{3,})\s*(\S*)\s*$/);
    if (block && fence?.[1] === block.fence && !fence[2]) block = null;
    else if (block) lines.push({ text: line, block });
    else if (fence) block = { fence: fence[1], lang: fence[2] };
    else {
      const [, tabs, marker, body] = line.match(/^(\t*)(?:(-|\d+\.) )?(.*)$/);
      lines.push({ text: tabs + body, tabs, marker });
    }
  });
  return lines;
}

// Prism.highlight と同じくフックを通す。埋め込みの言語 (php など) はフックでトークンに分けられる
function highlight(range, lang) {
  const grammar = Prism.languages[lang];
  if (!grammar) return;
  const env = { code: range.asString(), grammar, language: lang };
  Prism.hooks.run('before-tokenize', env);
  env.tokens = Prism.tokenize(env.code, env.grammar);
  Prism.hooks.run('after-tokenize', env);
  styleTokens(range, env.tokens, 0);
}

// 外側のトークンから先にスタイルを付け、内側のトークンで上書きする
function styleTokens(range, tokens, start) {
  tokens.reduce((pos, token) => {
    const end = pos + lengthOf(token);
    if (typeof token !== 'string') {
      [token.type, ...[].concat(token.alias ?? [])].forEach(type => TOKEN_STYLES[type]?.(range.getRange(pos, end).getTextStyle()));
      styleTokens(range, [].concat(token.content), pos);
    }
    return end;
  }, start);
}

function lengthOf(token) {
  return typeof token === 'string' ? token.length : [].concat(token.content).reduce((sum, t) => sum + lengthOf(t), 0);
}

// 連続するリストの行を 1 つのリストにまとめる。番号が途切れないよう、入れ子の行は記号が違っても親のリストに入れる
function listRuns(lines) {
  const runs = [];
  lines.forEach(({ tabs, marker }, i) => {
    if (!marker) return;
    const numbered = marker !== '-';
    const run = runs[runs.length - 1];
    if (run?.last === i - 1 && (tabs || run.numbered === numbered)) run.last = i;
    else runs.push({ numbered, first: i, last: i });
  });
  return runs;
}
