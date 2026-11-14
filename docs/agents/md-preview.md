# md-preview スキル

## 設計方針

- Markdown を `md2html` で HTML にし、`playwright-cli` で開いて見た目を確認し、報告するだけ。Markdown は直さない (ユーザの指定)。
- `md2html -o` は使わない。`open` が開くのはユーザのブラウザで、AI からは見えないため。
- ページ全体を 1 枚に撮る `screenshot --full-page` は使わない。長い文書 (`sample.md` で高さ 12,022px) では縮小されて表やコードが読めない。ページは画面 1 枚分ずつに分けて撮り、Mermaid の図は別に図ごとに撮る。
- 本文にコマンドやコードを書かず、試して初めて分かった落とし穴だけを書く。書き方は実行するエージェントに `playwright-cli --help` を見て組み立てさせる。`playwright-cli` はアルファ版 (1.59.0-alpha) でコマンドが変わり得るためと、Claude Code など他のツールでも同じ本文で通じるようにするため (ユーザの指摘)。
- `playwright-cli` に依存させ、Playwright MCP には対応させない。スキルは `md2html` をシェルで実行するので、シェルが使えればどのツールからでも `playwright-cli` を呼べる。MCP では `file:` を開くために HTTP サーバの起動と停止が要るうえ、ツール名もツールごとに違う。

## 調査記録

- Playwright の MCP ツールは `file:` の URL を開けない。生成した HTML の表示確認は、出力先のディレクトリを `python3 -m http.server --bind 127.0.0.1` で配信して開く。作業ファイルはリポジトリ直下の `.playwright-mcp/` に作られるので、確認後に消す。
- `playwright-cli` も既定では `file:` を開けない (`Allowed protocols: http:, https:, about:, data:`)。`run-code` の `page.goto` でも同じ。`{"allowUnrestrictedFileAccess": true}` を書いた設定ファイルを `open --config=` で渡すと開ける (microsoft/playwright#39560)。
