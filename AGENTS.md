# AGENTS.md

## 概要

パーソナルな dotfiles。`home/` 以下にすべてのドットファイルを置き、`install` スクリプトで `~` にファイル単位でシンボリックリンクを作成する。作成したリンクのパスは `$XDG_STATE_HOME/dotfiles/manifest` に記録される。

## リポジトリ構成

- `home/` — `~` のディレクトリ構造を模倣
  - `.zshenv` — Zsh 起動ファイル（ZDOTDIR の解決のみ）
  - `.config/zsh/` — Zsh 設定（`$ZDOTDIR`）
  - `.config/vim/` — Vim 設定（XDG）
  - `.config/tmux/` — Tmux 設定（XDG）
  - `.config/git/` — Git 設定（XDG）
  - `.config/gh/` — GitHub CLI 設定（XDG）
  - `.config/lazygit/` — lazygit 設定（XDG）
  - `.config/marp/` — Marp（Markdown スライド）テーマ設定（XDG）
  - `.local/bin/md2html` — Markdown を自分用のスタイルの単一 HTML に変換するコマンド。Vim の `<leader>r` もこれを呼ぶ
  - `.local/share/pandoc/` — Pandoc の HTML テンプレート、スタイル、Lua フィルタ、スタイル確認用の `sample.md`（XDG）
  - `.asdfrc` — asdf バージョンマネージャー設定
  - `.default-npm-packages` — asdf-nodejs が Node.js のインストール直後に入れる npm グローバルパッケージの一覧
  - `.desktopinit` — デスクトップ環境初期化スクリプト
  - `.ghci` — GHCi（Haskell REPL）設定
  - `.gvimrc` — GVim 設定
  - `.ideavimrc` — IdeaVim（JetBrains IDE）設定
  - `.latexmkrc` — LaTeXmk 設定
  - `.markdownlint.json` — Markdown lint 設定
  - `.rubocop.yml` — RuboCop（Ruby lint）設定
  - `.stylish-haskell.yaml` — stylish-haskell フォーマッター設定
  - `.xkb/` — XKB キーボードレイアウト設定

- `docs/agents/` — AI 向けの領域ごとの文書 (下の「領域ごとの文書」を参照)
- `review-knowledge/` — `my-review` スキルがレビューに使う知識。`my-review-learn` スキルが書き込む

## 領域ごとの文書

仕様・設計方針・調査記録は、`docs/agents/` に領域ごとに置いている。この文書には、常に要る規則と以下の索引だけを置く。
その領域を触る前に、該当する文書を読むこと。不採用にした案や、試して初めて分かった落とし穴が書いてある。

- `docs/agents/zsh.md` — Zsh の設定を触るとき、対話シェルの起動を検証するとき
- `docs/agents/vim.md` — Vim の設定やプラグインを触るとき、Vim をヘッドレスで検証するとき
- `docs/agents/tmux.md` — Tmux の設定を触るとき、tmux コマンドで何かを検証するとき (ユーザの tmux サーバを壊さないための手順がある)
- `docs/agents/gh.md` — GitHub CLI のエイリアスやテンプレートを触るとき
- `docs/agents/pandoc.md` — `md2html` や Pandoc のテンプレート・スタイル・フィルタを触るとき
- `docs/agents/ai-tools.md` — AI 向けのグローバル指示や、Claude Code・Copilot CLI の設定を触るとき
- `docs/agents/ai-skills.md` — スキルを作る・直すとき (どのスキルにも共通の方針)
- `docs/agents/skill-evaluation.md` — スキルを評価するとき、サブエージェントや `claude -p` で実測するとき
- `docs/agents/implementation-review.md` — `implementation-review` スキルを触るとき
- `docs/agents/md-to-gslides.md` — `md-to-gslides` スキルを触るとき、Google スライドや Apps Script を操作するとき
- `docs/agents/md-preview.md` — `md-preview` スキルを触るとき、生成した HTML をブラウザで確認するとき
- `docs/agents/my-review.md` — `my-review` / `my-review-learn` スキルを触るとき

## コミットメッセージ

日本語で書いてよい。

## Git サブモジュール

`home/.config/vim/vim-plug` はサブモジュール（カスタムフォーク、`fix-branch-checkout` ブランチ）。クローン後に以下を実行:

```bash
git submodule update --init
```
