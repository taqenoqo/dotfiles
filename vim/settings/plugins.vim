if has('vim_starting')
    set runtimepath+=~/.vim/bundle/neobundle.vim
endif
call neobundle#begin(expand('~/.vim/bundle/'))
NeoBundleFetch 'Shougo/neobundle.vim'

NeoBundle 'surround.vim'
NeoBundle 'camelcasemotion'
NeoBundle 'Smooth-Scroll'
NeoBundle 'Shougo/neocomplcache'
NeoBundle 'Shougo/neosnippet'
NeoBundle 'Shougo/neosnippet-snippets'
NeoBundle 'scrooloose/nerdtree'
NeoBundle 'taglist.vim'
NeoBundle 'kien/ctrlp.vim'
NeoBundle 'thinca/vim-quickrun'
NeoBundle 'plasticboy/vim-markdown'
NeoBundle 'sudo.vim'
NeoBundle 'tyru/open-browser.vim'
NeoBundle 'h1mesuke/vim-alignta'
NeoBundle 'kannokanno/previm'
NeoBundle 'Shougo/vimproc.vim', {
    \ 'build' : {
        \ 'windows' : 'tools\\update-dll-mingw',
        \ 'cygwin' : 'make -f make_cygwin.mak',
        \ 'mac' : 'make -f make_mac.mak',
        \ 'linux' : 'make',
        \ 'unix' : 'gmake',
    \ },
\ }

if neobundle#tap('neocomplcache')
    let g:neocomplcache_enable_at_startup = 1
    let g:neocomplcache_enable_smart_case = 1
    let g:neocomplcache_auto_completion_start_length = 0
    let g:neocomplcache_enable_fuzzy_completion = 1
    inoremap <expr><C-n> neocomplcache#start_manual_complete()
    inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
    inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<S-TAB>"
    inoremap <silent> <Return> <C-r>=<SID>my_cr_function()<Return>
    function! s:my_cr_function()
        return pumvisible() ? neocomplcache#close_popup() : '\<Return>'
    endfunction
    inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
    inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
    inoremap <expr><C-y> neocomplcache#close_popup()
    inoremap <expr><C-e> neocomplcache#cancel_popup()
    autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
    autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
    autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
    autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
    autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
    if !exists('g:neocomplcache_omni_patterns')
        let g:neocomplcache_omni_patterns = {}
    endif
    let g:neocomplcache_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
    let g:neocomplcache_omni_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
    let g:neocomplcache_omni_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
    let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'

    call neobundle#untap()
endif

if neobundle#tap('vim-quickrun')
    let g:quickrun_config = {}
    let g:quickrun_config['mkd'] = {
            \'outputter' : 'null',
            \'command' : 'open',
            \'cmdopt' : '-a',
            \'args' : 'Marked',
            \'exec' : '%c %o %a %s'
        \}
    "let g:quickrun_config['markdown'] = {
    "\       'outputter' : 'null',
    "\       'exec' : ':PrevimOpen'
    "\   }

    call neobundle#untap()
endif

if neobundle#tap('camelcasemotion')
    map <silent> w <Plug>CamelCaseMotion_w
    map <silent> b <Plug>CamelCaseMotion_b
    map <silent> e <Plug>CamelCaseMotion_e
    omap <silent> ic <Plug>CamelCaseMotion_ie
    vmap <silent> ic <Plug>CamelCaseMotion_ie
    omap <silent> ac <Plug>CamelCaseMotion_iw
    vmap <silent> ac <Plug>CamelCaseMotion_iw

    call neobundle#untap()
endif

if neobundle#tap('neosnippet')
    let g:neosnippet#snippets_directory = '~/.vim/snippets/'
    imap <C-k> <Plug>(neosnippet_expand_or_jump)
    smap <C-k> <Plug>(neosnippet_expand_or_jump)
    xmap <C-k> <Plug>(neosnippet_expand_target)
    imap <expr><CR> pumvisible() ? "\<Plug>(neosnippet_expand)" : "\<CR>"
    imap <expr><Tab> pumvisible() ?
                \ "\<C-n>"
                \: neosnippet#jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<Tab>"
    smap <expr><TAB> neosnippet#jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<Tab>"

    call neobundle#untap()
endif

if neobundle#tap('vim-markdown')
    let g:vim_markdown_initial_foldlevel = 2

    call neobundle#untap()
endif

call neobundle#end()
filetype plugin indent on
NeoBundleCheck

