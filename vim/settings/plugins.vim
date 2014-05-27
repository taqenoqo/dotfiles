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
    omap <silent> ic <Plug>CamelCaseMotion_ie
    vmap <silent> ic <Plug>CamelCaseMotion_ie
    omap <silent> ac <Plug>CamelCaseMotion_iw
    vmap <silent> ac <Plug>CamelCaseMotion_iw

" 起動時にチェック
NeoBundleCheck

