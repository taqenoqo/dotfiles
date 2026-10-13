---
name: md-preview
description: Markdown ファイルを md2html で HTML にしてヘッドレスブラウザで開き、Mermaid の図・表・数式などの見た目をスクリーンショットで確認して報告する。Markdown の描画結果を確かめたいとき、Mermaid の図が正しく描けているかを見たいときに使う。Markdown の修正はしない。
---

# Markdown の見た目を確認する

Markdown を `md2html` で HTML にし、`playwright-cli` のヘッドレスブラウザで開いてスクリーンショットを撮り、見た目を確認して報告する。
このスキルは確認と報告だけを行う。崩れを見つけても Markdown は直さない。

コマンドの書き方は `playwright-cli --help` (サブコマンドごとの `--help` も) で、その場で確かめること。
以下は、試して初めて分かった落とし穴だけを書いている。

## 前提

- `md2html`、`playwright-cli`
- Mermaid と MathJax は CDN から読み込むので、ネットワークにつながっていること。

## 落とし穴

- `md2html` は HTML を標準出力に書き出し、画像の相対パスをカレントディレクトリから探す。Markdown のあるディレクトリで実行する。
- `playwright-cli` は既定で `file:` の URL を開けない (`Access to "file:" URL is blocked`)。`run-code` の中で `page.goto` しても同じ。
  `{"allowUnrestrictedFileAccess": true}` を書いた設定ファイルを `open --config` で渡すと開ける
  (https://github.com/microsoft/playwright/issues/39560)。キー名が変わっていたら、この Issue の辺りから調べ直す。
- Mermaid は読み込み後に図を 1 つずつ非同期で描画し、描き終えた要素 (`.mermaid`) に `data-processed` 属性を付ける。
  図が 12 個の文書では、最後の図まで約 18 秒かかった。全部に付くのを待ってから撮る。
- ページ全体を 1 枚に撮ると、長い文書では縮小されて表やコードが読めない。ページはビューポート 1 枚分ずつに分けて撮る。
  境目で図が切れることがあるので、Mermaid の図は別に要素ごとに撮る。
- 構文エラーの図にも `data-processed` が付き、「Syntax error in text」とエラーの箇所が描かれる。
- 同時に別のエージェントが使っていても衝突しないよう、作業ディレクトリとブラウザのセッション名は実行ごとに別にする。
  `playwright-cli` はログ類を `open` したディレクトリの `.playwright-cli/` に書くので、作業ディレクトリで `open` する。
- `run-code` の出力は `### Result` と `### Error` の節に分かれる。Error の節が無いことを確かめる。

## 確認すること

撮った画像を見て、主に以下を確かめる。

- Mermaid の図が描けているか。
- 図の中の文字が切れたり重なったりしていないか。
- 表・コードブロック・数式が崩れていないか。

## 片付けと報告

ブラウザのセッションを閉じ、作業ディレクトリを消す。
見つけた崩れを、どの図・どの箇所かが分かるように報告する。崩れが無ければそう伝える。
