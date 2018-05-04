" シンタックスハイライト
syntax on
colorscheme takenocolor

" タブ、改行などの表示
set list
set listchars=tab:»-,trail:-,eol:⏎,extends:»,precedes:«,nbsp:%

" 言語環境の設定
set fileencodings=ucs-bom,utf-8,iso-2022-jp,euc-jp,cp932

" インデント設定
set autoindent
set smartindent
set expandtab
set tabstop=4 shiftwidth=4 softtabstop=0

" <Leader> の設定
let mapleader = ' '

" 大小文字を区別しない検索
set ignorecase

" 制限なしにバックスペース
set backspace=indent,eol,start

" 行移動時に行頭にカーソルを移動させない
set nostartofline

" ステータスラインを表示する
set laststatus=2

" 行番号を表示する
set number

" コマンドをステータスラインに表示
set showcmd

" 補完候補を表示する
set wildmenu

" 折り返さない
set nowrap

" ビープ音の代わりに画面をフラッシュ
set visualbell

" カーソルの上下に表示する最低行数
set scrolloff=5

" インクリメンタルサーチ
set incsearch

" 検索結果のハイライト
set hlsearch

" 行結合時にスペースを入れない
set nojoinspaces

" 行の最大文字数と自動改行の設定
set textwidth=120

" swpファイル作らない
set noswapfile

" チルダファイル作らない
set nobackup

if has('persistent_undo')
    set noundofile
endif

" キーコードのタイムアウトをしない
set notimeout
set ttimeout
set ttimeoutlen=0

" conceal
set conceallevel=2

" スペルチェック
if v:version >= 704
    set spelllang+=cjk
endif

" 自動改行
autocmd FileType * setlocal formatoptions=roql

" バックアップを作成しないファイル
set backupskip=/tmp/*,/private/tmp/*

" 折り畳み設定
set foldlevel=2
set foldnestmax=2
set fillchars="vert:|,fold:"
set foldmethod=syntax
set foldtext=MyFoldText()
function MyFoldText()
    return getline(v:foldstart)
endfunction

" C-Lでハイライトもクリア
nnoremap <silent> <C-L> :noh<CR><C-L>

" ファイルを開いたときに以前のカーソル位置に移動
autocmd BufReadPost *
    \ if line("'\"") > 0 && line ("'\"") <= line("$") |
    \   exe "normal! g'\"" |
    \ endif

silent! source ~/.vimrc.local

