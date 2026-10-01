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
  oldSlides.filter(s => !ordered.includes(s)).forEach(s => s.remove());
  ordered.forEach((s, i) => s.move(i));
  store.setProperties(Object.fromEntries(slides.map((s, i) => [s.getObjectId(), JSON.stringify(DECK[i])])), true);
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

function fill(text, value) {
  if (typeof value === 'string') text.setText(value);
  if (Array.isArray(value)) text.setText(value.join('\n')).getListStyle().applyListPreset(SlidesApp.ListPreset.DISC_CIRCLE_SQUARE);
}
