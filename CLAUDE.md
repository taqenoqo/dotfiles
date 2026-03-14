# CLAUDE.md

このファイルは、Claude Code (claude.ai/code) がこのリポジトリで作業する際のガイダンスを提供します。

## 概要

GNU Stow で管理するパーソナルな dotfiles。`home/` 以下にすべてのドットファイルを置き、stow で `~` にシンボリックリンクを作成する。

## インストール

```bash
./install
# 実行内容: stow --no-folding -t ~ home
```

`--no-folding` により、ディレクトリ単位ではなくファイル単位でシンボリックリンクが作成される。

## リポジトリ構成

- `home/` — Stow パッケージのルート（`~` のディレクトリ構造を模倣）
  - `.zshrc.d/` — Zsh のモジュール設定（ファイル名順にロード）
  - `.vimrc.d/` — Vim のモジュール設定（`plugins/` にプラグインごとの設定）
  - `.vim/` — Vim ランタイム（カラースキーム、スニペット、CoC 設定、vim-plug サブモジュール）
  - `.tmux/` — Tmux ヘルパー（クリップボードスクリプト等）
  - `.pandoc/` — Pandoc の HTML テンプレートとスタイル

## 主要な設定詳細

### Zsh
- フレームワーク: Oh-My-Zsh（プラグイン約 20 個）
- ロード順: `.zshenv` → `.zshrc` → `.zshrc.d/*.zsh`（ソート順）
- カスタムプロンプトは `.zshrc.d/prompt.zsh`（ASCII アート + git/docker コンテキスト表示）

### Vim
- Leader: `<Space>`、LocalLeader: `,`
- プラグインマネージャー: vim-plug（`.vim/vim-plug/` にサブモジュール）
- LSP: CoC.nvim を **v0.0.82 に固定** — テストなしにアップグレードしないこと
- 設定はモジュール構成: `.vimrc` が `.vimrc.d/` 以下のファイルを source する
- undo/swap ファイルは `~/.vimcache` に保存

### Tmux
- プレフィックス: `Ctrl-T`
- Vi スタイルのキーバインド、マウス操作有効

### Git
- diff ページャー: `delta`（ライトテーマ、行番号表示、サイドバイサイド）
- マージ/diff ツール: `vimdiff`

## Git サブモジュール

`home/.vim/vim-plug` はサブモジュール（カスタムフォーク、`fix-branch-checkout` ブランチ）。クローン後に以下を実行:

```bash
git submodule update --init
```
