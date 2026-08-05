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

#### git レビューモード

`<Leader>gr` を押すと比較先の revision を尋ね、以下 3 つが同じ基準に切り替わる。
空入力で通常表示（ワークツリー基準）に戻る。

- NERDTree のファイルマーカー（`g:NERDTreeGitStatusDiffRef`）
- `<Leader>gd` の差分先（`GitDiffFromReviewRef()`）
- 行番号横の gutter（coc-git の `git.diffRevision`）

入力は `s:ResolveReviewBase()` で 1 つのコミットに解決してから 3 箇所へ配る。三点記法は
merge-base に、それ以外は `git rev-parse --verify` で解決する。渡す先ごとに revision の
解釈が違い、そのまま配ると基準がずれるため（詳細は調査記録）。

実装は `vimrc.d/plugins/git.vim` に置く。切り替え先が NERDTree に限らないため、
`nerdtree.vim` 側には `g:NERDTreeGitStatus*` の設定と表示フィルタだけを残している。

ツリーの表示には「隠す」と「マークする」の 2 軸があり、独立している。隠す対象（gitignore）は
revision によらないので `MyFilter` が `git ls-files` へ直接聞き、プラグインのマーカーには
依存しない。マーカー（差分）はプラグインが担当する。この 2 つを混ぜると、revision を変えた
ときに隠す判定まで巻き添えになる。

`g:NERDTreeGitStatusDiffRef` は `taqenoqo/nerdtree-git-plugin` フォークで追加したオプション。
このフォークは dotfiles の管理外（`$XDG_DATA_HOME/vim/plugged/`）にあるため、`PlugUpdate`
や再クローンで変更が失われる。フォークの master に取り込んでおくこと。

#### AI への選択範囲の受け渡し

`<Leader>y` でリポジトリルート相対パスと行番号をクリップボード（`+`）へヤンクする。
複数行の選択なら `path:30-44`、単一行なら `path:30`。リポジトリ外のファイルは絶対パス。
tmux の隣ペインで動く CLI エージェントに貼るための機能。

ツール固有の記法（`@path`）に寄せていないのは、Claude Code も Copilot CLI も行範囲を
指定する公式の記法を持たないため（詳細は調査記録）。素の `path:行` ならどちらも自然言語
として解釈でき、人間もそのまま読める。

実装は `vimrc.d/basic.vim`。プラグインに依存しないので `plugins/` 配下には置かない。

### Tmux
- プレフィックス: `Ctrl-T`
- `prefix+c` は、文字セルの縦横比が 16:9 より 21:9 に近いとき、新規ウインドウを開いて左右を 2:1 に分割し、左ペインを選択する。それ以外では1ペインの新規ウインドウを開く。
- `prefix+C` は、常に1ペインの新規ウインドウを開く。
- 条件判定は `if-shell -F` と tmux の数値フォーマットで行う。分岐内の複数コマンドは `\;` でつながず、波括弧でグループ化する。

## 設計方針

### AI スキル（home/.copilot/skills/）

- サブエージェントを束ねるスキルは、オーケストレーション自体を manager サブエージェント（`manager.md`）に委譲する。`SKILL.md` は前提確認・モデル解決・manager 起動・結果中継だけの薄いランチャーにする。メイン会話の文脈を成果物に持ち込まないためと、会話履歴を全ツール往復に引きずるコストを避けるため。manager 自身のモデルは指定せず、デフォルトモデルを引き継ぐ。
- プレースホルダ記法の使い分け: `{NAME}` はそのテンプレートを起動する側が埋める入力。`<説明>` は出力フォーマット中の「ここに値が入る」の意。テンプレート本文で子テンプレートのプレースホルダに言及するときは波括弧を付けずに書き、起動側が埋める対象と機械的に区別できるようにする。
- harness 依存の一時領域 (`/tmp` やセッション領域など) は、サブエージェントからの解決や書き込み可否が不安定なことがある。対象リポジトリ内に成果物専用ディレクトリが既にあるスキルでは、その配下に専用 workdir を設け、最後に削除する方式を優先する。

### Vim script

- 関数定義に `!` を付けない (`function` を使う)。`!` なしでも同じスクリプトの再 source は例外扱いで黙って置き換わるため、vimrc を読み直しても困らない。一方 `!` を付けると別スクリプトの同名関数を黙って上書きし、衝突に気づけなくなる (詳細は調査記録)。

## 調査記録

- `home/.config/zsh/conf.d/alias.zsh` の `copilot` alias は `--add-dir "$HOME/.config/ai"` と `--add-dir "$HOME/dotfiles/"` を付けている。したがって、これら配下への参照だけでは許可ダイアログの直接原因になりにくい。
- Copilot の許可ダイアログに `.../Workspace/<repo>/.config/ai/AGENTS.md` のようなパスが出る場合は、リポジトリ相対の `.config/ai/AGENTS.md` を読もうとしている可能性を優先して疑う。
- `TMPDIR` や `/tmp` を使う抽象指示は、親ディレクトリの解釈は安定しても、サブエージェントのファイル操作可否は安定しなかった。
- `my-repo-report` では `.repo-report/.work/` 配下を WORK_DIR にすると、複数回のサブエージェント実験で作成・読み書き・再利用・削除まで安定して成功した。
- low モデル (Haiku 4.5 で実測) が出力する定義の行番号は、Read ツールの行番号付き表示の転記なのでほぼ完璧 (2,863 行・128 関数のファイルで start / end ほぼ全一致)。行番号の精度を理由に決定的スクリプトを足す必要はない。
- ただし low モデルの `end − start + 1` の算術は 1〜5% で off-by-one する。±1 が許容できない数値は LLM に計算させないこと。
- 「〜は省略してよい」という許可の一文は、low モデルには「全項目で省略する」として作用する (アウトラインの説明の記入率が 100% → 0% に落ちた)。必須の出力は「全項目に書く」と書くこと。
- `home/.config/vim/vimrc.d/plugins/nerdtree.vim` の `MyFilter` は gitignore 対象を隠すフィルタであって、変更のないファイルを隠すものではない。通常表示でも全ファイルが並ぶ。判定は `git ls-files` に直接聞いており、プラグインのマーカーには依存しない。
- `g:NERDTreeGitStatusShowIgnored` を 0 にしてはいけない。`-` は普段 `MyFilter` に隠れて見えないが、`f` でフィルタを解除したときに gitignore 対象を見分ける唯一の手がかりになる。「もう使っていない印」に見えるので切りたくなるが、切ると `f` の意味が薄れる。
- `f` (`NERDTreeMapToggleFilters`) は `g:NERDTreeIgnore` と `NERDTreeAddPathFilter` で登録したフィルタをまとめて無効化する。個別には切り替えられない。
- nerdtree-git-plugin の conceal は `[` `]` を隠しているだけで、印自体はそのまま表示されている。印の系統を増やすと連結されて表示幅が広がり、`AlignIfConceal` による行頭の整列が崩れる。
- coc-git は `git show <rev>:<path>` でファイルを取るため、`git.diffRevision` には単一コミットしか渡せない。`origin/main...` のような三点記法はエラーになるうえ握り潰され、gutter が古い基準のまま黙って残る。
- fugitive の `Gvdiffsplit` は逆に三点記法を merge-base へ解決する。同じ文字列でも coc-git と解釈が食い違うので、revision は配る前に解決しておくこと。
- fugitive の `Gvdiffsplit` は解決できない revision をエラーにせず、ファイルパスとして開く。タイポが静かに空バッファになる。
- nerdtree-git-plugin の job コールバックは spawn 時点の revision でパースしなければならない。実行中に `g:NERDTreeGitStatusDiffRef` が変わると `git diff` の出力を porcelain パーサに渡して例外になる。job の opts に revision を持たせて照合している。
- Vim は `-c` を VimEnter より後に実行する。`NERDTreeAddPathFilter` など VimEnter で登録される設定をヘッドレス検証するときは、`-c 'autocmd VimEnter * ...'` 経由にしないと空振りする。
- Vim の `-c` は 10 個までしか受け付けない。超えた分は黙って無視され、末尾の `qa!` も実行されないためハングしたように見える。ヘッドレス検証でコマンドを多く流すときは `-S <script>` を使う。
- Vim の `function` は `!` なしでも、同じスクリプトを再 source したときだけは例外として黙って置き換わる (`userfunc.txt` の "There is one exception")。E122 で止まるのは別スクリプトが同名を定義したときだけ。`!` を付けないことによる不便は無く、衝突の検出だけが得られる。
- サンドボックス下の Vim は `@+` (クリップボード) への書き込みが黙って失敗し、レジスタが空のまま読める。クリップボードを触る検証はサンドボックスを外し、実行の前後で退避・復元すること。
- Claude Code も Copilot CLI も `@path` でファイルを参照する記法は持つが、行範囲を指定する公式の記法は無い。`@file#L76-82` は claude-code の Issue #26993 に出てくるだけで、ドキュメント化されていない。

## コミットメッセージ

日本語で書いてよい。

## Git サブモジュール

`home/.config/vim/vim-plug` はサブモジュール（カスタムフォーク、`fix-branch-checkout` ブランチ）。クローン後に以下を実行:

```bash
git submodule update --init
```
