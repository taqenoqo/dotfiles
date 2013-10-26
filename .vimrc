" neobundle関連
if has('vim_starting')
    set runtimepath+=~/.vim/bundle/neobundle.vim
endif
call neobundle#rc(expand('~/.vim/bundle/'))
NeoBundleFetch 'Shougo/neobundle.vim'

" プラグイン
NeoBundle 'Smooth-Scroll'

NeoBundle 'scrooloose/nerdtree'
NeoBundle 'taglist.vim'
NeoBundle 'SrcExpl'
NeoBundle 'surround.vim'

NeoBundle 'Shougo/neocomplcache'
    let g:neocomplcache_enable_at_startup = 1
    " タブで補完
    inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
    " オムニ補完
    autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
    autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
    autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
    autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
    autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

NeoBundle 'hallison/vim-markdown'
NeoBundle 'thinca/vim-quickrun'
NeoBundle 'tyru/open-browser.vim'
    let g:quickrun_config = {}
    if (isdirectory('/Applications/Marked.app'))
        let g:quickrun_config.markdown = {
            \ 'outputter' : 'null',
            \ 'command'   : 'open',
            \ 'cmdopt'    : '-a',
            \ 'args'      : 'Marked',
            \ 'exec'      : '%c %o %a %s',
        \ }
    endif

NeoBundle 'LeafCage/foldCC'
    set foldtext=foldCC#foldtext()
    let g:foldCCtext_head = ''
    let g:foldCCtext_tail = ''
    set fillchars=vert:\|
    set foldcolumn=1
    set foldlevel=3
    noremap z<Space> za

NeoBundle 'camelcasemotion'
    map <silent> w <Plug>CamelCaseMotion_w
    map <silent> b <Plug>CamelCaseMotion_b
    map <silent> e <Plug>CamelCaseMotion_e
    omap <silent> ic <Plug>CamelCaseMotion_iw
    vmap <silent> ic <Plug>CamelCaseMotion_iw
    omap <silent> ac <Plug>CamelCaseMotion_ie
    vmap <silent> ac <Plug>CamelCaseMotion_ie

" 起動時にチェック
NeoBundleCheck

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

" ステータスライン
augroup EventHook
    autocmd!
    autocmd InsertLeave * call s:changeFace('(*ﾟーﾟ)♪\ ')
    autocmd CursorMoved * call s:changeFace('(*ﾟーﾟ)')
    autocmd InsertEnter * call s:changeFace('(*ﾟД\ ﾟ)')
    autocmd BufWritePost * call s:changeFace('(*^ーﾟ)')
    autocmd CursorHold * call s:changeFace('ｃ⌒っ*ﾟーﾟ)っ')
augroup END
let s:oldFace = ""
function GetSyntaxType()
    return synIDattr(synID(line('.'), col('.'), 0), 'name')
endfunction
function s:changeFace(face)
    if a:face == s:oldFace
        return
    endif
    silent let l:line = 'set statusline=\ ' . a:face
    silent let l:line .= '\ %<%l,%c=%B[%{GetSyntaxType()}]%=%n:%p%%\ %m%r%h%w%y\ %t\ [%{&fenc}][%{&ff}]\ '
    silent exec l:line
    silent let s:oldFace = a:face
endfunction

" IDEっぽくするコマンド
command -nargs=0 -bar IDEMode call s:startIDEMode()
command -nargs=0 -bar IDEModeClose call s:endIDEMode()
function s:initTlist()
    " Tlistのwindow設定
    let g:Tlist_Use_Right_Window = 1
    let g:Tlist_WinWidth = 32
    " 表示順
    let g:Tlist_Sort_Type = "order"
    " スペース等を省いたコンパクトな表示
    let g:Tlist_Compact_Format = 0
    " Tlistのwindowだけが残った場合終了する
    let g:Tlist_Exit_OnlyWindow = 1
    " 現在のバッファのタグツリーだけ表示
    let g:Tlist_File_Fold_Auto_Close = 1
    " タグツリーのアウトライン非表示
    let g:Tlist_Enable_Fold_Column = 0
    " 現在のバッファだけ表示
    let g:Tlist_Show_One_File = 1
endfunction
function s:initSrcExpl()
    " window設定
    let g:SrcExpl_winHeight = 7
    " プレビューの表示間隔(ms)
    let g:SrcExpl_refreshTime = 10
    " 競合のプラグイン
    let g:SrcExpl_pluginList = [
        \ "__Tag_List__",
        \ "_NERD_tree_",
        \ "Source_Explorer"
    \ ]
    " 開くときにtagsファイルの更新を許可しない
    let g:SrcExpl_isUpdateTags = 0
endfunction
function s:initNerdTree()
    " window設定
    let g:NERDTreeWinSize = 24
    let g:NERDTreeWinPos = "left"
endfunction
function s:startIDEMode()
    call s:initSrcExpl()
    call s:initTlist()
    call s:initNerdTree()
    call s:endIDEMode()
    SrcExpl
    NERDTree
    Tlist
endfunction
function s:endIDEMode()
    silent SrcExplClose
    silent NERDTreeClose
    silent TlistClose
endfunction

