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
  - `.local/share/pandoc/` — Pandoc の HTML テンプレートとスタイル（XDG）
  - `.asdfrc` — asdf バージョンマネージャー設定
  - `.desktopinit` — デスクトップ環境初期化スクリプト
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

## 設計方針

### AI スキル（home/.copilot/skills/）

- サブエージェントを束ねるスキルは、オーケストレーション自体を manager サブエージェント（`manager.md`）に委譲する。`SKILL.md` は前提確認・モデル解決・manager 起動・結果中継だけの薄いランチャーにする。メイン会話の文脈を成果物に持ち込まないためと、会話履歴を全ツール往復に引きずるコストを避けるため。manager 自身のモデルは指定せず、デフォルトモデルを引き継ぐ。
- プレースホルダ記法の使い分け: `{NAME}` はそのテンプレートを起動する側が埋める入力。`<説明>` は出力フォーマット中の「ここに値が入る」の意。テンプレート本文で子テンプレートのプレースホルダに言及するときは波括弧を付けずに書き、起動側が埋める対象と機械的に区別できるようにする。
- harness 依存の一時領域 (`/tmp` やセッション領域など) は、サブエージェントからの解決や書き込み可否が不安定なことがある。対象リポジトリ内に成果物専用ディレクトリが既にあるスキルでは、その配下に専用 workdir を設け、最後に削除する方式を優先する。

## 調査記録

- `home/.config/zsh/conf.d/alias.zsh` の `copilot` alias は `--add-dir "$HOME/.config/ai"` と `--add-dir "$HOME/dotfiles/"` を付けている。したがって、これら配下への参照だけでは許可ダイアログの直接原因になりにくい。
- Copilot の許可ダイアログに `.../Workspace/<repo>/.config/ai/AGENTS.md` のようなパスが出る場合は、リポジトリ相対の `.config/ai/AGENTS.md` を読もうとしている可能性を優先して疑う。
- `TMPDIR` や `/tmp` を使う抽象指示は、親ディレクトリの解釈は安定しても、サブエージェントのファイル操作可否は安定しなかった。
- `my-repo-report` では `.repo-report/.work/` 配下を WORK_DIR にすると、複数回のサブエージェント実験で作成・読み書き・再利用・削除まで安定して成功した。

## コミットメッセージ

日本語で書いてよい。

## Git サブモジュール

`home/.config/vim/vim-plug` はサブモジュール（カスタムフォーク、`fix-branch-checkout` ブランチ）。クローン後に以下を実行:

```bash
git submodule update --init
```
