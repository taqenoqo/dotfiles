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

function fill(text, markdown) {
  if (markdown == null) return;
  const lines = markdown.split('\n').map(line => line.match(/^(\t*)(?:(-|\d+\.) )?(.*)$/));
  text.setText(lines.map(([, tabs, , body]) => tabs + body).join('\n'));
  text.find('`[^`\n]+`').reverse().forEach(code => {
    code.getTextStyle().setFontFamily('Roboto Mono');
    code.clear(code.getLength() - 1, code.getLength());
    code.clear(0, 1);
  });
  // リストにすると行頭のタブが消えて後ろの段落の位置がずれるので、段落は毎回取り直す
  listRuns(lines).forEach(({ numbered, first, last }) => {
    const paragraphs = text.getParagraphs();
    text.getRange(paragraphs[first].getRange().getStartIndex(), paragraphs[last].getRange().getEndIndex())
      .getListStyle().applyListPreset(numbered ? SlidesApp.ListPreset.DIGIT_ALPHA_ROMAN : SlidesApp.ListPreset.DISC_CIRCLE_SQUARE);
  });
}

// 連続するリストの行を 1 つのリストにまとめる。番号が途切れないよう、入れ子の行は記号が違っても親のリストに入れる
function listRuns(lines) {
  const runs = [];
  lines.forEach(([, tabs, marker], i) => {
    if (!marker) return;
    const numbered = marker !== '-';
    const run = runs[runs.length - 1];
    if (run?.last === i - 1 && (tabs || run.numbered === numbered)) run.last = i;
    else runs.push({ numbered, first: i, last: i });
  });
  return runs;
}
