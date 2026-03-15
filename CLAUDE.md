# CLAUDE.md

このファイルは、Claude Code (claude.ai/code) がこのリポジトリで作業する際のガイダンスを提供します。

## 概要

パーソナルな dotfiles。`home/` 以下にすべてのドットファイルを置き、`install` スクリプトで `~` にシンボリックリンクを作成する。

## インストール

```bash
./install
```

`home/` 以下のファイル・シンボリックリンクをファイル単位で `~` にリンクする。
インストール済みの場合は先に `uninstall` を実行してから再インストールする。
作成したリンクのパスは `$XDG_STATE_HOME/dotfiles/manifest` に記録される。

```bash
./uninstall
```

マニフェストを元にリンクを削除し、空になったディレクトリを親に向かって辿って削除する。

## リポジトリ構成

- `home/` — `~` のディレクトリ構造を模倣
  - `.zshenv` — Zsh 起動ファイル（ZDOTDIR の解決のみ）
  - `.config/zsh/` — Zsh 設定（`$ZDOTDIR`）
  - `.config/vim/` — Vim 設定（XDG）
  - `.config/tmux/` — Tmux 設定（XDG）
  - `.config/git/` — Git 設定（XDG）
  - `.local/share/pandoc/` — Pandoc の HTML テンプレートとスタイル（XDG）
  - `.asdfrc` — asdf バージョンマネージャー設定
  - `.ghci` — GHCi（Haskell REPL）設定
  - `.gvimrc` — GVim 設定
  - `.ideavimrc` — IdeaVim（JetBrains IDE）設定
  - `.latexmkrc` — LaTeXmk 設定
  - `.markdownlint.json` — Markdown lint 設定
  - `.rubocop.yml` — RuboCop（Ruby lint）設定
  - `.stylish-haskell.yaml` — stylish-haskell フォーマッター設定
  - `.xkb/` — XKB キーボードレイアウト設定

## 主要な設定詳細

### Zsh
- フレームワーク: Oh-My-Zsh（プラグイン約 20 個）
- ロード順: `.zshenv` → `$ZDOTDIR/.zshenv` → `$ZDOTDIR/.zshrc` → `$ZDOTDIR/conf.d/*.zsh`（ソート順）
- カスタムプロンプトは `$ZDOTDIR/conf.d/prompt.zsh`（ASCII アート + git/docker コンテキスト表示）

#### .zshenv の分割構造

`~/.zshenv` は ZDOTDIR の解決と `$ZDOTDIR/.zshenv` の source のみを行う。
環境変数・PATH 設定はすべて `$ZDOTDIR/.zshenv` に集約している。

この構造の理由: `ZDOTDIR` は export されるため、tmux の新ウィンドウ等のサブシェルは
`ZDOTDIR` を継承した状態で起動し、`~/.zshenv` ではなく `$ZDOTDIR/.zshenv` を読む。
すべての設定を `$ZDOTDIR/.zshenv` に置くことで、どちらの起動パターンでも
同じ設定が適用される。

### Vim
- Leader: `<Space>`、LocalLeader: `,`
- プラグインマネージャー: vim-plug（`.config/vim/vim-plug/` にサブモジュール）
- LSP: CoC.nvim を **v0.0.82 に固定** — テストなしにアップグレードしないこと
- 設定はモジュール構成: `.config/vim/vimrc` が `.config/vim/vimrc.d/` 以下のファイルを source する
- undo/swap/backup ファイルは `$XDG_CACHE_HOME/vim` に保存

### Tmux
- プレフィックス: `Ctrl-T`
- Vi スタイルのキーバインド、マウス操作有効

### Git
- diff ページャー: `delta`（ライトテーマ、行番号表示、サイドバイサイド）
- マージ/diff ツール: `vimdiff`

## Git サブモジュール

`home/.config/vim/vim-plug` はサブモジュール（カスタムフォーク、`fix-branch-checkout` ブランチ）。クローン後に以下を実行:

```bash
git submodule update --init
```
