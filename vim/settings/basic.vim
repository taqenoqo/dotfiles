" ファイル形式別プラグイン
filetype plugin indent on

" 言語環境の設定
set encoding=utf-8
set fileencodings=ucs-bom,utf-8,iso-2022-jp,euc-jp,cp932

" シンタックスハイライト
syntax on
colorscheme nuyo

" タブ、改行などの表示
highlight NonText guifg=lightgray ctermfg=lightgray
highlight SpecialKey guifg=lightgray ctermfg=lightgray
set list
set listchars=tab:»-,trail:-,eol:↲,extends:»,precedes:«,nbsp:%

" インデント設定
set autoindent
set smartindent
set expandtab
set tabstop=4 shiftwidth=4 softtabstop=4

" 大小文字を区別しない検索
set ignorecase

" 制限なしにバックスペース
set backspace=indent,eol,start

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

" 全角文字の文字幅を正しくする
set ambiwidth=double

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
autocmd FileType * setlocal fo-=t fo-=c fo-=r fo-=o

" swpファイル作らない
set noswapfile

" チルダファイル作らない
set nobackup

" キーコードのタイムアウトをしない
set notimeout

" 変更の差分を表示するコマンド
if !exists(":DiffOrig")
    command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
            \ | wincmd p | diffthis
endif

if filereadable(expand('~/.vimrc.local'))
    source ~/.vimrc.local
endif

