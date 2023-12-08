" シンタックスハイライト
syntax on
colorscheme takenocolor

" タブ、改行などの表示
set list
set listchars=tab:»-,trail:-,eol:↓,extends:»,precedes:«,nbsp:%

" 言語環境の設定
set fileencodings=ucs-bom,utf-8,iso-2022-jp,euc-jp,cp932

" インデント設定
set autoindent
set smartindent
set expandtab
set tabstop=4 shiftwidth=4 softtabstop=0

" <Leader> の設定
let mapleader = ' '
let maplocalleader = ','

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

" sign バー常時表示
set signcolumn=yes

" C-A や C-X で増減される対象
set nrformats=bin,hex,alpha

function s:SetupCacheFiles()
    let l:cache_dir = $HOME . '/.vimcache'
    let l:swap_dir = l:cache_dir . '/swap'
    let l:backup_dir = l:cache_dir . '/backup'
    let l:undo_dir = l:cache_dir . '/undo'
    let l:viminfo_path = l:cache_dir . '/viminfo'
    if !isdirectory(l:cache_dir) | call mkdir(l:cache_dir) | endif
    if !isdirectory(l:swap_dir) | call mkdir(l:swap_dir) | endif
    if !isdirectory(l:backup_dir) | call mkdir(l:backup_dir) | endif
    if !isdirectory(l:undo_dir) | call mkdir(l:undo_dir) | endif

    " スワップファイル (クラッシュしたとき用のファイル)
    set swapfile
    execute 'set directory=' . l:swap_dir

    " チルダファイル (バックアップファイル)
    " 上書き前にバックアップを作り、上書き後もそのファイルを残す
    set backup
    execute 'set backupdir=' . l:backup_dir

    " undo ファイル
    if has('persistent_undo')
        set undofile
        execute 'set undodir=' . l:undo_dir
    endif

    " viminfoファイル
    execute 'set viminfo+=n' . l:viminfo_path
endfunction
call s:SetupCacheFiles()

" マウス操作
set mouse=a
set ttymouse=xterm2

" キーコードのタイムアウトをしない
set notimeout
set ttimeout
set ttimeoutlen=0

" conceal
set conceallevel=2

" CursorHold autocmd の待ち時間
set updatetime=100

" 補完設定
set completeopt=menuone,noinsert,noselect
set shortmess+=c

" スペルチェック
if v:version >= 704
    set spelllang+=cjk
endif

" 自動改行
autocmd FileType * setlocal formatoptions=roql

" バックアップを作成しないファイル
set backupskip=/tmp/*,/private/tmp/*

" diff 設定
set diffopt=filler,context:10,iwhite,closeoff,internal,algorithm:minimal

" 折り畳み設定
set foldlevel=2
set foldnestmax=2
set fillchars="vert:|,fold:"
set foldmethod=syntax
set foldtext=MyFoldText()
function MyFoldText()
    return getline(v:foldstart)
endfunction

" C-Space 解除
imap <Nul> <Nop>

" C-Lでハイライトもクリア
nnoremap <silent> <C-L> :noh \| :pclose<CR><C-L>

" dm でマーク全削除
nnoremap <silent> dm :delmarks! \| delm A-Z0-9<CR>

nnoremap <C-P> :tabprevious<CR>
nnoremap <C-N> :tabnext<CR>

" ファイルを開いたときに以前のカーソル位置に移動
autocmd BufReadPost *
    \ if line("'\"") > 0 && line ("'\"") <= line("$") |
    \   exe "normal! g'\"" |
    \ endif

" DiffOrig コマンド
command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis | wincmd p | diffthis

" dein 関連設定
let g:dein#auto_recache = 1
set runtimepath+=~/.vim/dein.vim
let s:script_dir = expand('<sfile>:p:h')
if dein#load_state('~/.dein')
    call dein#begin('~/.dein')
    call dein#load_toml(s:script_dir . '/plugins.toml')
    call dein#end()
    call dein#save_state()
endif
if dein#check_install()
  call dein#install()
endif
call map(dein#check_clean(), "delete(v:val, 'rf')")
autocmd VimEnter * call dein#call_hook('post_source')

filetype plugin indent on

silent! source ~/.vimrc.local

