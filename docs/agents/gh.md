# gh

## 仕様

- エイリアスは `.config/gh/config.yml` に置く。`reqt` と `myi` は、プロジェクトを環境変数 `GH_PROJECT_OWNER` と `GH_PROJECT_NUM` で受け取る。環境変数は dotfiles の外で設定する。
- `myi` は、プロジェクトで自分が担当する open な Issue を、ステータス → リポジトリ → Issue の 3 段で出す。ステータスは `GH_PROJECT_STATUSES` (カンマ区切り) の順で、Status が空の Issue は出さない。
- Issue は更新が新しい順に並べ、2 列目の更新日時を新しいほど濃い灰色にする。リポジトリは、最近更新された Issue があるものから並ぶ。
- テンプレートは `.config/gh/myi.tmpl` に分けている。エイリアスはステータスごとに `{{$status := "…"}}` を前に付けたテンプレートをつなげ、`gh api graphql` の検索 1 回 (約 2 秒) で全段を出す。

## 調査記録

- gh の `--template` には並べ替えもグループ化も無い。変数の再代入 (`{{$x = …}}`) はできるので、初出の行で見出しを出す二重ループで束ねる。テンプレートは環境変数を読めないので、シェルから `{{$x := "…"}}` を前に付けて渡す。`--jq` は `$ENV` を読めるが、`--template` と併用できない。
- gh のテンプレートの `color` は 256 色の番号 (`"242"`、`"232+b"`) を受け付ける。`timeago` は `just now` / `N minutes ago` / `N hours ago` / `N days ago` / `N months ago` / `N years ago` を返すので、`regexMatch` で古さを段に分けられる。
- `gh project item-list` は、ボード上の並び順 (`ProjectV2.items` の `orderBy` は POSITION しか無い) で返し、ビューの並べ替えは反映されない。`--query` にも並べ替えの記法は無い。更新順にするには Issue 検索 (`project:OWNER/NUM … sort:updated-desc`) を `gh api graphql` で使う。
- `gh api` は端末への出力をページャに通す。検証で `script` から叩くときは `GH_PAGER=cat` を付けないと、less が入力を待って止まる。
- GitHub Projects の Status は、プロジェクトを作ると最初から付いている単一選択のフィールド (Todo / In Progress / Done)。ボード表示の列分けと、閉じたら Done にする組み込みの自動化の基準になっている。
