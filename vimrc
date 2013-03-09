" 言語環境の設定
set encoding=utf-8
set fileencodings=ucs-bom,utf-8,iso-2022-jp,euc-jp,cp932

" ファイル形式別プラグイン
filetype plugin on

" タブ、改行などの表示
highlight NonText guifg=lightgray ctermfg=lightgray
highlight SpecialKey guifg=lightgray ctermfg=lightgray
set list
set listchars=tab:»-,trail:-,eol:↲,extends:»,precedes:«,nbsp:%

" シンタックスハイライト
syntax on

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
set formatoptions=q

" 変更の差分を表示するコマンド
if !exists(":DiffOrig")
    command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
            \ | wincmd p | diffthis
endif

" ステータスライン
highlight StatusLine term=reverse cterm=reverse
augroup EventHook
    autocmd!
    autocmd InsertLeave * call s:changeFace('(*ﾟーﾟ)♪\ ')
    autocmd CursorMoved * call s:changeFace('(*ﾟーﾟ)')
    autocmd InsertEnter * call s:changeFace('(*ﾟД\ ﾟ)')
    autocmd BufWritePost * call s:changeFace('(*^ーﾟ)')
    autocmd CursorHold * call s:changeFace('ｃ⌒っ*ﾟーﾟ)っ')
augroup END
let s:oldFace = ""
function! s:changeFace(face)
    if a:face == s:oldFace
        return
    endif
    silent let l:line = 'set statusline=\ ' . a:face
    silent let l:line .= '\ %<%l,%c=%B%=%n:%p%%\ %m%r%h%w%y\ %t\ [%{&fenc}][%{&ff}]\ '
    silent exec l:line
    silent let s:oldFace = a:face
endfunction

