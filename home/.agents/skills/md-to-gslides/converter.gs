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
  const oldSlides = pres.getSlides();
  DECK.forEach(({ layout, texts }) => {
    const slide = pres.appendSlide(pres.getLayouts().find(l => l.getObjectId() === layout));
    placeholdersOf(slide).forEach((s, i) => fill(s.getText(), texts[i]));
  });
  oldSlides.forEach(s => s.remove());
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
