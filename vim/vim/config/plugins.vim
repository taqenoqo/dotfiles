if has('vim_starting')
    set runtimepath+=~/.vim/bundle/neobundle.vim
endif
call neobundle#begin(expand('~/.vim/bundle/'))
NeoBundleFetch 'Shougo/neobundle.vim'

NeoBundle 'yonchu/accelerated-smooth-scroll'

NeoBundle 'surround.vim'
if neobundle#tap('surround.vim')
    let g:surround_no_mappings = 1

    nmap ds <Plug>Dsurround
    nmap cs <Plug>Csurround
    nmap s <Plug>Ysurround
    xmap s <Plug>VSurround

    call neobundle#untap()
endif

NeoBundle 'camelcasemotion'
if neobundle#tap('camelcasemotion')
    nmap <silent> w <Plug>CamelCaseMotion_w
    nmap <silent> b <Plug>CamelCaseMotion_b
    nmap <silent> e <Plug>CamelCaseMotion_e
    omap <silent> ic <Plug>CamelCaseMotion_ie
    vmap <silent> ic <Plug>CamelCaseMotion_ie
    omap <silent> ac <Plug>CamelCaseMotion_iw
    vmap <silent> ac <Plug>CamelCaseMotion_iw

    call neobundle#untap()
endif

NeoBundle 'nathanaelkane/vim-indent-guides'
if neobundle#tap('vim-indent-guides')
    let g:indent_guides_enable_on_vim_startup = 1
    let g:indent_guides_guide_size = 1
    let g:indent_guides_auto_colors = 0

    hi IndentGuidesOdd  ctermbg=194 ctermfg=145
    hi IndentGuidesEven ctermbg=194 ctermfg=145

    call neobundle#untap()
endif

NeoBundleLazy 'h1mesuke/vim-alignta'
if neobundle#tap('vim-alignta')
    call neobundle#config({
        \ 'autoload': {
            \ 'commands': 'Alignta'
        \ }
    \ })

    call neobundle#untap()
endif

NeoBundleLazy 'scrooloose/nerdtree'
if neobundle#tap('nerdtree')
    call neobundle#config({
        \ 'autoload': {
            \ 'commands': {
                \ 'name': 'NERDTree',
                \ 'complete': 'dir'
            \ }
        \ }
    \ })

    function! neobundle#tapped.hooks.on_source(bundle)
        let g:NERDTreeWinSize = 32
    endfunction

    function! neobundle#tapped.hooks.on_post_source(bundle)
        call nerdtree#postSourceActions()
    endfunction

    function! s:nerdtree_auto_start()
        if argc() == 0 && !exists("s:exists_std_in")
            NERDTree
        endif
    endfunction

    augroup nerdtree
        autocmd!
        autocmd StdinReadPre * let s:exists_std_in = 1
        autocmd VimEnter * call s:nerdtree_auto_start()
    augroup END

    call neobundle#untap()
endif

NeoBundleLazy 'Xuyuanp/nerdtree-git-plugin', { 'depends': 'scrooloose/nerdtree' }
if neobundle#tap('nerdtree-git-plugin')
    call neobundle#config({
        \ 'autoload': {
            \ 'on_source': 'nerdtree'
        \ }
    \ })

    function! neobundle#tapped.hooks.on_source(bundle)
        let g:NERDTreeIndicatorMap = {
            \ "Modified" : "*",
            \ "Staged" : "+",
            \ "Untracked" : "!",
            \ "Renamed" : ">",
            \ "Unmerged" : "=",
            \ "Deleted" : "X",
            \ "Dirty" : "-",
            \ "Clean" : "c",
            \ "Unknown" : "?"
        \ }
    endfunction

    call neobundle#untap()
endif

NeoBundleLazy 'Shougo/neocomplcache'
if neobundle#tap('neocomplcache')
    call neobundle#config({
        \ 'autoload': {
            \ 'insert': 1
        \ }
    \ })

    function! neobundle#tapped.hooks.on_source(bundle)
        let g:neocomplcache_enable_at_startup = 1
        let g:neocomplcache_enable_smart_case = 1
        let g:neocomplcache_auto_completion_start_length = 0
        let g:neocomplcache_enable_fuzzy_completion = 1
        if !exists('g:neocomplcache_omni_patterns')
            let g:neocomplcache_omni_patterns = {}
        endif
        let g:neocomplcache_omni_patterns = {
            \ 'c': '\w',
            \ 'cpp': '\w',
            \ 'php': '\w',
            \ 'ruby': '\w',
        \ }

        inoremap <expr> <C-n> neocomplcache#start_manual_complete()
        inoremap <expr> <S-TAB> pumvisible() ? "\<C-p>" : "\<S-TAB>"
        inoremap <expr> <C-h> neocomplcache#smart_close_popup()."\<C-h>"
        inoremap <expr> <BS> neocomplcache#smart_close_popup()."\<C-h>"
        inoremap <expr> <C-y> neocomplcache#close_popup()
        inoremap <expr> <C-e> neocomplcache#cancel_popup()
        inoremap <expr> <CR> <SID>cr_neocomplcache()
        inoremap <expr> <TAB> <SID>tab_neocomplcache()

        function! s:cr_neocomplcache()
            return pumvisible() ? neocomplcache#close_popup() : "\<Return>"
        endfunction

        function! s:tab_neocomplcache()
            return pumvisible() ? "\<C-n>" : "\<TAB>"
        endfunction
    endfunction

    call neobundle#untap()
endif

NeoBundleLazy 'Shougo/neosnippet', { 'depends': 'Shougo/neocomplcache' }
if neobundle#tap('neosnippet')
    call neobundle#config({
        \ 'autoload': {
            \ 'on_source': 'neocomplcache'
        \ }
    \ })

    function! neobundle#tapped.hooks.on_source(bundle)
        let g:neosnippet#snippets_directory = '~/.vim/snippets/'
        let g:neosnippet#enable_preview = 1

        smap <expr><TAB> neosnippet#jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<Tab>"
        imap <expr> <CR> <SID>cr_neosnippet()
        imap <expr> <TAB> <SID>tab_neosnippet()

        function! s:cr_neosnippet()
            return pumvisible() && neosnippet#expandable() ? "\<Plug>(neosnippet_expand)" : s:cr_neocomplcache()
        endfunction

        function! s:tab_neosnippet()
            return !pumvisible() && neosnippet#jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : s:tab_neocomplcache()
        endfunction
    endfunction

    call neobundle#untap()
endif

NeoBundleLazy 'Shougo/neosnippet-snippets', { 'depends': 'Shougo/neosnippet' }
if neobundle#tap('neosnippet-snippets')

    call neobundle#config({
        \ 'autoload': {
            \ 'on_source': 'neosnippet'
        \ }
    \ })

    call neobundle#untap()
endif

NeoBundleLazy 'thinca/vim-quickrun'
if neobundle#tap('vim-quickrun')
    call neobundle#config({
        \ 'autoload': {
            \ 'mappings': '<Leader>r',
            \ 'commands': {
                \ 'name': 'QuickRun',
                \ 'complete': 'customlist,quickrun#complete'
            \ }
        \ }
    \ })

    function! neobundle#tapped.hooks.on_source(bundle)
        let g:quickrun_config = {}
        let g:quickrun_config['mkd'] = {
            \ 'outputter' : 'null',
            \ 'command' : 'open',
            \ 'cmdopt' : '-a',
            \ 'args' : 'Marked',
            \ 'exec' : '%c %o %a %s'
        \ }
    endfunction

    call neobundle#untap()
endif

NeoBundleLazy 'plasticboy/vim-markdown'
if neobundle#tap('vim-markdown')
    call neobundle#config({
        \ 'autoload': {
            \ 'filetypes': 'mkd'
        \ }
    \ })

    function! neobundle#tapped.hooks.on_source(bundle)
        let g:vim_markdown_initial_foldlevel = 2
    endfunction

    call neobundle#untap()
endif

NeoBundleLazy 'Shougo/unite.vim'
if neobundle#tap('unite.vim')
    call neobundle#config({
        \ 'autoload': {
            \ 'commands': {
                \ 'name': 'Unite',
                \ 'complete': 'customlist,unite#complete#source'
            \ }
        \ }
    \ })

    call neobundle#untap()
endif

NeoBundleLazy 'Shougo/unite-outline', { 'depends': 'Shougo/unite.vim' }
if neobundle#tap('unite-outline')
    call neobundle#config({
        \ 'autoload': {
            \ 'unite_sources': 'outline',
            \ 'commands': [ 'Outline', 'OutlineStart', 'OutlineStop']
        \ }
    \ })

    function! neobundle#tapped.hooks.on_source(bundle)
        call unite#custom#profile('outline', 'context', {
            \ 'no_quit': 1,
            \ 'vertical': 1,
            \ 'winwidth': 40,
            \ 'direction': 'botright',
            \ 'hide_source_names': 1,
        \ })

        function! s:outline()
            if &foldmethod == 'marker'
                silent UniteClose
                Unite -profile-name=outline outline:folding
            elseif unite#sources#outline#get_outline_info(&filetype) != {}
                silent UniteClose
                Unite -profile-name=outline outline
            endif
        endfunction

        function! s:outline_start()
            augroup outline
                autocmd!
                autocmd BufWinEnter * Outline
            augroup END
            call s:outline()
        endfunction

        function! s:outline_stop()
            augroup outline
                autocmd!
            augroup END
            silent UniteClose
        endfunction

        command! -nargs=0 Outline call s:outline()
        command! -nargs=0 OutlineStart call s:outline_start()
        command! -nargs=0 OutlineStop call s:outline_stop()
    endfunction

    call neobundle#untap()
endif

call neobundle#end()
filetype plugin indent on
NeoBundleCheck

