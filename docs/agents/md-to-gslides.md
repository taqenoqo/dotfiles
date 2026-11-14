# md-to-gslides スキル

## 設計方針

- 変換は3段で行う。テンプレートをコピーし、コピーに紐づく GAS がレイアウトへ文章を流し込み、最後に AI がスクリーンショットを見てはみ出しを直す。以下の方法はユーザが試して不採用にしたので、再提案しない。
    - Marp
    - pptx の取り込み (LibreOffice と Google スライドで見た目が異なる)
    - Gemini による生成 (デザインを指定しても独自のデザインを出力する)
- gws CLI など API を使う方法は GCP プロジェクトを要するが、会社の権限では作れない。Playwright 用の Chrome 拡張もストアからインストールできない。そこで、一時プロファイルのデバッグ用 Chrome にユーザがログインし、playwright-cli で CDP 接続する。GAS は Apps Script エディタの UI から実行する。
- Chrome と一時プロファイルは、ユーザが作業の終わりを告げるまで残す。生成のたびに片付けると、続けて直しを頼まれるたびにログインし直すことになり、ユーザが面倒がった。
    - プロファイルを固定の場所に残す案 (ログイン状態がディスクに残り続け、Chrome 136 の保護も効かない) と、普段の Chrome に接続する案 (接続ごとに許可のダイアログが出て、普段のブラウザを操作させることになる) は採らなかった。
- テーマを取り込むのではなく、テンプレートのデッキごとコピーする。テンプレートは固定せず、毎回 URL を受け取る。
- 中間形式は YAML にしない。GAS にそのまま貼れる JS リテラル `DECK` を使い、レイアウトは `inspect` で得た objectId で指定する。
- スクリプトには `@OnlyCurrentDoc` を付け、権限をそのプレゼンテーションだけに絞る。
- 箇条書きは、テンプレートに依存しない `DISC_CIRCLE_SQUARE` プリセット (●○■) で付ける。テーマの ■ は再現しない (理由は調査記録)。
- 生成したデッキの URL を草案の front matter `gslides:` に残し、あれば同じデッキへの反映、無ければ新規作成とする。毎回コピーし直すとバインドスクリプトが新しくなり、承認をやり直すことになるため。
    - 単独のスクリプトから `openById` で開く案は、`presentations` スコープが要り `@OnlyCurrentDoc` を失うので採らない。
- 反映では `DECK` の要素ごとに差分を取る。`build` は、生成したスライドの objectId と `JSON.stringify(要素)` の対応を DocumentProperties に残し、前回と同じ要素のスライドは作り直さずに再利用する。
    - 手直しの有無は検出しない。草案と Google スライドの両方で変わったページは、草案を優先して作り直す。
    - 生成の記録が無いスライド (手で足したもの) は消さず、直前に残る生成済みスライドの後ろに付ける。
    - 変わっていない要素を一字も変えないため、前回の `DECK` はローカルに持たず、Apps Script エディタに残っているコードから取り出して書き換える。
- コードブロックは、Apps Script の中で Prism を動かし、トークンごとに文字色を付ける。`DECK` が Markdown の文字列のままなので差分の反映が効き、スライド上で直せ、`@OnlyCurrentDoc` も保てる。
    - 画像にする案 (スライド上で直せない) と、手元で色を付けて色の範囲を `DECK` に書く案 (`DECK` が読めなくなり、差分の判定にも響く) は採らなかった。
    - Prism は毎回 CDN から `$WORK` に取り、依存する言語は公式の `dependencies.js` で解決する。リポジトリには置かない。
    - 配色は md2html のコードの配色に揃える。背景の箱は付けないので、暗い背景のテンプレートでは読みにくい (未解決)。
    - Markdown のコードブロックの中にあるコードには色が付かない (理由は調査記録)。
    - コードの行は、ブロックの最後の行以外で段落後の間隔を 0 にする。プレースホルダの段落の間隔がコードの 1 行ごとに付き、行が離れるため。最後の行の間隔は残し、後ろの段落や次のブロックとの区切りにする。
    - 実際の Apps Script で、Haskell・Markdown・PHP・TypeScript (別名 `ts`) の色付けと、言語名なし・未知の言語が等幅だけになることを確かめた。

## 調査記録

- GAS (SlidesApp) と Slides API では、テーマ既定の箇条書き記号 (UI で ⌘⇧8 を押したときに付く ■ など) を指定できない。
    - `applyListPreset` にはプリセット (9 種) の指定が必須。REST の `createParagraphBullets` も、省略すると `BULLET_DISC_CIRCLE_SQUARE` になる。
    - 箇条書きかどうかは段落ごとの属性で、プレースホルダから継承されない。
    - ■ を再現するには、既存の ■ 段落を `insertRange` で複製するしかない。テンプレートに依存するため不採用にした。
- `applyListPreset` は、行頭のタブの数でネストの深さを決め、そのタブを取り除く。
- `getPlaceholders()` は画像などのプレースホルダも返す。それらに `asShape()` を呼ぶと例外になるので、`getPageElementType()` で SHAPE に絞る。
- Apps Script エディタを UI 操作するときの注意点。
    - 保存が完了するまで、新しい関数は関数選択の一覧に出ない。保存が完了した後も一覧がしばらく古いままのことがあり、一度開いた一覧は後から更新されないことがある (目的の関数が 30 秒出なかった。選んだ後に選択が元に戻ったこともある)。開き直すと出るので、選択欄が目的の関数名になるまで開き直す。大きなコード (Prism を連結した約 40KB) を保存したときに起きた。
    - 関数を選んでから選択が反映されるまでに少し間がある。その前に実行を押すと前回選んだ関数が走る (`build` のつもりで `inspect` が走った)。選択欄の表示が目的の関数名になるのを待ってから実行すること。
    - 初回実行時の承認が済むと、実行はそのまま続く。実行ボタンを押し直さず、ログの完了を待つ。
    - `build` の実行が一度だけ、エラーを出さずに何もせず終わったことがある (原因不明)。実行後は必ずスライドを見て結果を確かめる。
- Apps Script の承認は、スクリプトのプロジェクトごとにアカウント側に残る。ブラウザのプロファイルを作り直しても、同じバインドスクリプトなら承認画面は出なかった。
- Google スライドのバインドスクリプトは、デッキで初めて「拡張機能 > Apps Script」を開いたときに作られる。以後は同じプロジェクトが開き、前回保存したコードも残っている。
- デッキをコピーしても、レイアウトの objectId は変わらない。
- `PropertiesService.getDocumentProperties()` はバインドスクリプトで使え、追加の承認は要らなかった。
- `Slide.move(index)` の index は移動前の並びで数える。望む順に先頭から `move(0)`, `move(1)`, … と呼べば、その順に並ぶ。
- 組織が管理する Chrome プロファイルでは、拡張機能の更新ページや `chrome://managed-user-profile-notice/` のタブが勝手に開き、playwright-cli のタブ番号がずれる。`chrome://` のタブを `tab-close` すると固まって戻らない。
- Chrome 136 から、`--remote-debugging-port` は既定のユーザデータディレクトリでは無視され、`--user-data-dir` で別のディレクトリを指す必要がある (https://developer.chrome.com/blog/remote-debugging-port)。Chrome 144 からは `chrome://inspect/#remote-debugging` で許可すれば起動中の普段の Chrome に接続できるが、CDP クライアントの接続ごとに許可のダイアログが出る (https://developer.chrome.com/docs/devtools/agents/get-started/configuration 、https://github.com/ChromeDevTools/chrome-devtools-mcp/issues/1794)。
- playwright-cli の `run-code` の出力は `### Result` と `### Error` の節に分かれる。Result の節だけを抜き出すと、エラーが黙って消える。
- Google スライドのフォントサイズ欄は、選択範囲にサイズが混在していると空になる。
- Google スライドには、Google ドキュメントのような組み込みのコードブロックが無い。
- 空のプレゼンテーションの既定のテーマでは、本文のプレースホルダに `setText` で入れた段落すべてに段落後の間隔 (`spaceBelow` 12pt) が付く。
- Prism (1.30.0) は `window` も `document` も無い V8 で `Prism.tokenize` が動く。依存する言語は `dependencies.js` の `getLoader(components, ids).getIds()` が、別名を解決して読み込み順に返す。Prism に無い ID もそのまま返すので、`components.json` の `languages` で絞る。
- `Prism.tokenize` だけでは、フックで行う処理が抜ける。php などのテンプレート言語は `before-tokenize` と `after-tokenize` のフックでトークンに分けるので、`Prism.highlight` と同じくフックを通す。Markdown の中のコードは HTML にする段 (`wrap` フック) で色付けされるので、トークンの段では色が付かない。
