# Vim

## 仕様

- Leader: `<Space>`、LocalLeader: `,`
- プラグインマネージャー: vim-plug（`.config/vim/vim-plug/` にサブモジュール）
- LSP: CoC.nvim を **v0.0.82 に固定** — テストなしにアップグレードしないこと
- 設定はモジュール構成: `.config/vim/vimrc` が `.config/vim/vimrc.d/` 以下のファイルを source する
- undo/swap/backup ファイルは `$XDG_CACHE_HOME/vim` に保存
- Visual mode 中は statusline に `wordcount().visual_chars` で選択文字数を表示する
- statusline のカーソル列は `%v` で表示幅を示す。全角文字は2列、タブは展開後の幅で数える。
- `<Leader>F` は `NERDTreeFind` を実行し、現在のファイルをツリーで表示して NERDTree へフォーカスを移す。
- Vista (outline) は、バッファの表示時とタブ移動時に、言語サーバがシンボルを返すのを最大 5 秒待って自動で開く。`g:vista_auto_open = 0` で止まる。手で閉じても、次にファイルを開けばまた開く。
- `<C-w><CR>` は、NERDTree を左 (`g:NERDTreeWinSize`)、Vista を右 (`g:vista_sidebar_width`) に戻し、閉じていれば開く。残りのウインドウは中央に上下へ均等に並べ、カーソルは元の編集ウインドウに残す。実装は `vimrc.d/plugins/vista.vim`。

### git レビューモード

`<Leader>gR` を押すと比較先の revision を尋ね、以下 3 つが同じ基準に切り替わる。
空入力で通常表示（ワークツリー基準）に戻る。

- NERDTree のファイルマーカー（`g:NERDTreeGitStatusDiffRef`）
- `<Leader>gd` の差分先（`GitDiffFromReviewRef()`）
- 行番号横の gutter（coc-git の `git.diffRevision`）

`<Leader>gr` は、ワークツリー基準と、最後に `<Leader>gR` で指定した revision とを切り替える。
未指定なら `origin/HEAD...`（既定ブランチとの merge-base）を使う。入力を覚えておき、
切り替えのたびに解決し直すので、HEAD が進んでも merge-base が追従する。

入力は `s:ResolveReviewBase()` で 1 つのコミットに解決してから 3 箇所へ配る。三点記法は
merge-base に、それ以外は `git rev-parse --verify` で解決する。渡す先ごとに revision の
解釈が違い、そのまま配ると基準がずれるため（詳細は調査記録）。

実装は `vimrc.d/plugins/git.vim` に置く。切り替え先が NERDTree に限らないため、
`nerdtree.vim` 側には `g:NERDTreeGitStatus*` の設定、表示フィルタ、`R` の更新処理だけを残している。

ツリーの表示には「隠す」と「マークする」の 2 軸があり、独立している。隠す対象（gitignore）は
revision によらないので `MyFilter` が `git ls-files` へ直接聞き、プラグインのマーカーには
依存しない。マーカー（差分）はプラグインが担当する。この 2 つを混ぜると、revision を変えた
ときに隠す判定まで巻き添えになる。

`R` は `NERDTreeRefreshRootWithIgnored()` を呼び、gitignoreキャッシュとツリーを更新した後、
現在の `g:NERDTreeGitStatusDiffRef` を再指定してgitマーカーの非同期更新も起動する。

`g:NERDTreeGitStatusDiffRef` は `taqenoqo/nerdtree-git-plugin` フォークで追加したオプション。
このフォークは dotfiles の管理外（`$XDG_DATA_HOME/vim/plugged/`）にあるため、`PlugUpdate`
や再クローンで変更が失われる。フォークの master に取り込んでおくこと。

### AI への選択範囲の受け渡し

`<Leader>y` でリポジトリルート相対パスと行番号をクリップボード（`+`）へヤンクする。
複数行の選択なら `path:30-44`、単一行なら `path:30`、ノーマルモードならパスのみ。リポジトリ外のファイルは絶対パス。
tmux の隣ペインで動く CLI エージェントに貼るための機能。

ツール固有の記法（`@path`）に寄せていないのは、Claude Code も Copilot CLI も行範囲を
指定する公式の記法を持たないため（詳細は調査記録）。素の `path:行` ならどちらも自然言語
として解釈でき、人間もそのまま読める。

実装は `vimrc.d/basic.vim`。プラグインに依存しないので `plugins/` 配下には置かない。

## 設計方針

### Vim script

- 関数定義に `!` を付けない (`function` を使う)。`!` なしでも同じスクリプトの再 source は例外扱いで黙って置き換わるため、vimrc を読み直しても困らない。一方 `!` を付けると別スクリプトの同名関数を黙って上書きし、衝突に気づけなくなる (詳細は調査記録)。

### Vista

- 自動で開くきっかけを Vim の起動 (`User CocNvimInit`) に結び付けない。tmux の Note ウインドウのようにファイルなしで起動すると、待ち時間が NERDTree 相手に空振りして終わり、後からファイルを開いても Vista が開かなかった。きっかけは「シンボルを返せるバッファが表示されたこと」(`BufWinEnter`) にする。
- 待ち処理 (ポーリング) 自体は外さない。言語サーバは最初の対象ファイルを開いてから起動するので、表示の時点ではまだシンボルを返せない (marksman で約 1.5 秒)。`Vista coc` はシンボルが空だとウインドウを開かず、再試行もしない。

## 調査記録

- 導入済みの `DanBradbury/copilot-chat.vim` (`c7342e4`) は、`:CopilotChatModels` で `GET /models` の候補を選ばせて `g:copilot_chat_data_dir/config.json` の `model` に保存するが、送信は常に `/chat/completions` へ行う。`gpt-5.6-luna` のように一覧にあってもこのエンドポイントでは使えないモデルがあるため、選択画面だけで互換性を判断しない。この環境ではプラグインの既定値である `gpt-4o` が動作した。
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
- ヘッドレス検証でタイマーから `execute("edit …")` を呼ぶと `E930: Cannot use :redir inside execute()` で失敗し、ファイルが開かれなかった。`feedkeys(":edit …\<CR>")` なら通る。
- 端末が要る Vim の検証は `script -q <log> vim …` で起動できるが、サンドボックス内では `openpty: Operation not permitted` で失敗する。サンドボックスを外すと `$TMPDIR` も別の場所になるので、ログの読み出しも同じ側で行う。
- coc の初期化前に `CocAction` を呼ぶと `coc.nvim not ready when invoke CocAction` の例外になる (E605)。起動直後から呼び得る場所では `g:coc_service_initialized` を先に確かめる。これを怠った版では、ファイルを直接開いても Vista が一度も開かなかった。
- Vim の `function` は `!` なしでも、同じスクリプトを再 source したときだけは例外として黙って置き換わる (`userfunc.txt` の "There is one exception")。E122 で止まるのは別スクリプトが同名を定義したときだけ。`!` を付けないことによる不便は無く、衝突の検出だけが得られる。
- Vim 組み込みの `syntax/stylus.vim` (patch 9.1.0386 で `wavded/vim-stylus` から取り込まれた) には、色の定義 (`hi def link`) も土台の CSS 構文の読み込みも無い。`.styl` は `filetype=stylus` と判定され構文グループも作られるのに、色が一切付かない。Vim 9.2.0167 でも、2026-10 時点の Vim の master でも同じ。
- 組み込みの `syntax/stylus.vim` には読み込み済みの判定 (`b:current_syntax` のチェック) も無い。構文ファイルは `runtimepath` 上の同名ファイルがすべて読まれ、組み込み版はプラグインの後に読まれるので、同じグループ名を使う別実装を上書きする。`iloginow/vim-stylus` は単体なら最も細かく色が付くが、この上書きで単語のほとんどが `stylusVariable` になり、`wavded/vim-stylus` より悪くなる。wavded が無事なのは、組み込み版がその一部を写したもので定義が同じだから。
- サンドボックス下の Vim は `@+` (クリップボード) への書き込みが黙って失敗し、レジスタが空のまま読める。クリップボードを触る検証はサンドボックスを外し、実行の前後で退避・復元すること。
- Claude Code も Copilot CLI も `@path` でファイルを参照する記法は持つが、行範囲を指定する公式の記法は無い。`@file#L76-82` は claude-code の Issue #26993 に出てくるだけで、ドキュメント化されていない。
- ヘッドレスの `vim -es` は `cpoptions` に `C` が入り、autoload の行継続が `E697` で失敗する。スクリプトの先頭で `set cpo&vim` する。
