# Pandoc (md2html)

## 設計方針

- pandoc のオプションは `home/.local/bin/md2html` だけに書く。`quickrun.vim` は `md2html` を呼ぶだけにし、シェルから叩いたときと `<leader>r` とで結果が食い違わないようにする。HTML は標準出力へ書き出し、`--` より後ろの引数は HTML を書き出す側の pandoc に渡す。`-o` を付けると `$TMPDIR/md2html/<ファイル名>.html` へ上書きで書き出し、`open` でブラウザに開く。
- Mermaid の図はブラウザ側で描画する。`mermaid.lua` がコードブロックを `div.mermaid` に置き換え、`template.html` が CDN の Mermaid を読み込む。数式の MathJax も CDN から読むので、同じ方式に揃えている。
- `mermaid-filter` で変換時に SVG へ焼き込む方式は不採用。同梱の Chromium が x86_64 用で arm64 では起動せず、図が黙って消えていた (詳細は調査記録)。
- 図の入れ物は `pre` ではなく `div` にする。公式の例は `pre.mermaid` だが、`style.css` のコードブロック用の枠・等幅フォント・スクロール指定が図にもかかるため。
- 図は元の大きさの 0.75 倍で表示し、それでも本文の幅を超える図は幅に合わせて縮める。Mermaid の既定では幅を超える図だけが縮むので、細い図 (クラス図など) が等倍のまま、横長の図 (フローチャートなど) より大きく見えていた。`template.html` が描画のたびに SVG の `max-width` を元の幅の 0.75 倍にしている。横長の図は今も小さく、倍率は揃いきらない (0.46〜0.75)。
- 表は `table.lua` で `div.table-wrap` に包み、div をスクロールの枠、表を `width: max-content` にする。列は中身の幅になり、上限で折り返し、はみ出した分は表ごとに横スクロールする。表そのものをスクロールの枠 (`display: block; overflow-x: auto`) にすると、ブラウザが列を縮めてページ幅に押し込むので採らない。
- 列幅の上限は `main` の幅に対する割合 (`cqi`) で指定し、「35% と、枠の幅 ÷ 列数 の大きい方」とする。列数は `table.lua` が `--cols` として div に渡す。`main` に `container-type: inline-size` を付けているのはこのため。上限を列数によらない固定値にすると、2 列の表はセルが長くても枠の 7 割ほどで止まり、右が余る。
- 「短い列 + 長い列」の 2 列の表では、長い列が 50% で止まり余りが残る (未解決)。
- 上限をセルではなく表全体に掛ける方式 (`table` に `max-width: max(100%, 列数 × 20cqi)`) は試して不採用にした。再提案しない。列幅の配分がブラウザ任せになり、中身の長い列へ幅が寄って、短い列が 2 文字幅まで潰れる。
- 上限の 35% という値や割合の基準を、確認なしに変えない。基準を `div.table-wrap` に移して値を 40% に合わせ直したところ、3 列以上の表の列幅が変わり、ユーザに差し戻された。
- 列が潰れるのを折り返しの規則で防ぐ方法は、どちらも試して不採用にした。再提案しない。
    - `word-break: keep-all` (句読点の間で折り返さない): 句が上限を超えると強制的な折り返しになり、禁則が効かず「。」だけの行ができる。
    - `word-break: auto-phrase` (文節で折り返す): 列が多いと各列が 8 字ほどまで縮む。Chrome 限定で、HTML に `lang="ja"` も要る。
- 印刷時はスクロールできないので、表を紙の幅に収める (div のスクロールと表の `max-content` は `@media screen` に限定)。列が多い表で列が潰れるのは未解決。
- 印刷時はコードを折り返す。はみ出した分を切る方式にしなかったのは、紙ではスクロールできず、中身を残すため。
- 印刷時は、見出しの直後と、見出し直後の段落の後ろでは改ページしない。コードブロックや表は 1 ページにまとめておきたいので、それらの途中での改ページを許す方法は採らなかった。見出しの直後ではない段落は対象外で、段落だけがページの下に残ることがある (未解決)。

## 調査記録

- `home/.local/share/pandoc/style.css` は `style.styl` から生成したファイル。直接編集せず、`stylus home/.local/share/pandoc/style.styl` で再生成する。`stylus` は `home/.default-npm-packages` 経由で asdf の Node.js に入る (入れた直後は `asdf reshim nodejs` が要る)。
- Stylus (0.64.0) は `:not(ul,ol)` のカンマをセレクタの区切りとして扱う。`&` を入れ子にすると `li > :not(ul:first-child, li ol):first-child` のように崩れた形で出力される。`style.styl` の `li` の `:first-child` と `:last-child` がこの状態で残っている。
- `mermaid-filter` (1.4.7) は mermaid-cli の 10 系に固定で、puppeteer が入れる Chromium は x86_64 用。arm64 では `spawn Unknown system error -86` で起動に失敗する。旧 Lua フィルタは失敗したブロックを削除していたため、pandoc は正常終了し、正しい図まで消えていた。実行したディレクトリに `mermaid-filter.err` も残る。
- 親の `font-weight` が 300 のとき、`strong` の既定値 `bolder` は 400 にしかならない。ヒラギノ明朝 ProN には W3 と W6 しか無く、300 も 400 も W3 で表示されるので、太字にならない。`body` に 300 を指定しないこと。
- Mermaid は図を 1 つずつ非同期で描画し、描き始める前の要素に `data-processed` を付ける (`mermaid.ts` の `runThrowsErrors`)。描き終えた印ではない。構文エラーの図にも付き、「Syntax error in text」の SVG が描かれる。`sample.md` (図 12 個) では、最後の図まで約 18 秒かかった。
- Mermaid の図を CSS の `zoom` で縮めてはいけない。Mermaid が縮んだ状態で文字の幅を測るため箱が小さく描かれ、クラス図や ER 図の文字が切れた。
- `mermaid.run()` に引数のオブジェクトを渡すと、既定の `querySelector: '.mermaid'` が使われない。対象が無いという例外を `suppressErrors: true` が黙って捨て、何も描かれない。
- pandoc のテンプレートでは `$` が変数の記号になるので、`template.html` の JS にテンプレートリテラル (`${…}`) は書けない。
- pandoc は、パイプテーブルのソースに `--columns` (既定 72) を超える行があると、表を全幅にし、列幅を区切り行のダッシュの本数の比で固定する (`<colgroup>` を出力する)。中身と無関係な配分になるので、`md2html` で `--columns=100000` を渡して止めている。
- 表のセルの `max-width` は Chrome で効く (仕様上は未定義)。`%` は表自身の幅が基準になり循環するので使えない。`cqi` はコンテナのコンテンツ領域 (padding を除く) が基準。
- 表のセルの `max-width` は、Chrome では `box-sizing` の指定によらず、padding を含めたセル全体の幅を制限する。`35cqi` (222.6px) に対しセルの幅は 221.1px だった。上限から padding を引く必要はなく、引くと 2 列の合計が枠より 48px 狭くなった。
- `border-collapse: collapse` の表は、列幅の合計より 1px 広くなる (外周の枠線の半分ずつがはみ出す)。列幅の合計を枠の幅ちょうどにすると、1px 分の横スクロールが出る。
- Stylus は `max()` と `min()` を組み込み関数として評価し、`calc()` や `var()` を渡すと `cannot coerce … to unit` で失敗する。CSS の関数として出力するには `unquote("max(…)")` と書く。
- `overflow-wrap: anywhere` は列の最小幅も 1 文字にするので、表の中の短いコードまで単語の途中で切れる。`break-word` は最小幅に影響しないので、入りきらないときだけ折り返す。
- `table.lua` が包むのは Markdown 記法の表だけ。HTML で直接書いた `<table>` は pandoc が表として解釈しないので包まれず、余白もスクロールも付かない。
- quickrun は、設定に `command` が無ければ `type` の値をコマンド名に使う。`g:quickrun_config['markdown']` の `type` を消すと、既定の `markdown` → `markdown/pandoc` が引かれ、その `exec` (`%c --from=markdown --to=html …`) を継承してしまう。`'type': 'md2html'` はこれを避けつつコマンドを指定している。
- `quickrun.vim` の設定は Vim の起動時に読まれる。変更後は Vim を読み込み直すまで `<leader>r` に反映されない。`home/` に新しいファイルを足したときは、`./install` でリンクするまで `~` 側から見えない。
- macOS の既定設定では、トラックパッド使用時にスクロールバーがスクロール中しか出ない。スクロールできる表が、右端で切れているだけに見える。
- Chrome は、紙の幅からはみ出す中身があると、収まるようにページ全体を縮小して印刷する (長い行のあるコードブロック 1 つで全体が約 7 割になった)。はみ出しを見せたまま縮小だけ止めることはできない。`overflow: clip` と `overflow-clip-margin` でも縮小した。
- 印刷結果は、ヘッドレスの Chrome で PDF にして Read ツールで見られる (`--headless --print-to-pdf=<pdf> --no-pdf-header-footer --user-data-dir=<一時ディレクトリ> file://<html>`)。`--user-data-dir` で普段のプロファイルと分ける。PDF の出力後もプロセスが終了しないので、ファイルができたら止める。
- `page-break-after: avoid` は Chrome の印刷で効く。ページ下端の見出しが、直後のコードブロックと一緒に次のページへ送られることを PDF で確認した。
