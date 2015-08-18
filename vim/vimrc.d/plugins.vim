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

NeoBundle 'TAK3N0K0/vim-indent-guides'
if neobundle#tap('vim-indent-guides')
    let g:indent_guides_enable_on_vim_startup = 1
    let g:indent_guides_guide_size = 1
    let g:indent_guides_auto_colors = 0
    let g:indent_guides_right_align = 1

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
        let g:neocomplcache_skip_auto_completion_time = 0.1
        let g:neocomplcache_force_omni_patterns = {
            \ 'c': '\w',
            \ 'cpp': '\w',
            \ 'php': '\w',
            \ 'ruby': '\w',
            \ 'java': '\w',
            \ 'typescript': '\v(^|[^[:alnum:]_."''])\w|\w\.',
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
        let g:quickrun_config['markdown'] = {
            \ 'outputter' : 'null',
            \ 'command' : 'open',
            \ 'cmdopt' : '-a',
            \ 'args' : 'Marked',
            \ 'exec' : '%c %o %a %s'
        \ }
        let g:quickrun_config['html'] = {
            \ 'outputter' : 'browser',
            \ 'command' : 'cat',
        \ }
    endfunction

    call neobundle#untap()
endif

NeoBundleLazy 'tpope/vim-markdown'
if neobundle#tap('vim-markdown')
    call neobundle#config({
        \ 'autoload': {
            \ 'filetypes': 'markdown'
        \ }
    \ })

    function! neobundle#tapped.hooks.on_source(bundle)
        if !exists('g:markdown_fenced_languages')
            let g:markdown_fenced_languages = []
        endif
        call add(g:markdown_fenced_languages, 'zsh')
        call add(g:markdown_fenced_languages, 'c')
        call add(g:markdown_fenced_languages, 'ruby')
        call add(g:markdown_fenced_languages, 'vim')
        call add(g:markdown_fenced_languages, 'java')
        call add(g:markdown_fenced_languages, 'haskell')
        hi link markdownCodeDelimiter Delimiter
        hi link markdownListMarker Identifier
    endfunction

    function! neobundle#tapped.hooks.on_post_source_typescript(bundle)
        if !exists('g:markdown_fenced_languages')
            let g:markdown_fenced_languages = []
        endif
        call add(g:markdown_fenced_languages, 'typescript')
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

NeoBundleLazy 'koron/nyancat-vim'
if neobundle#tap('nyancat-vim')
    call neobundle#config({
        \ 'autoload': {
            \ 'commands': [ 'Nyancat', 'Nyancat2']
        \ }
    \ })

    call neobundle#untap()
endif

NeoBundleLazy 'vim-stylus'
if neobundle#tap('vim-stylus')
    call neobundle#config({
        \ 'autoload': {
            \ 'filename_patterns': '.*\.styl'
        \ }
    \ })

    call neobundle#untap()
endif

NeoBundle 'Shougo/vimproc.vim'
if neobundle#tap('vimproc.vim')
    call neobundle#config({
        \ 'build' : {
            \ 'windows' : 'tools\\update-dll-mingw',
            \ 'cygwin' : 'make -f make_cygwin.mak',
            \ 'mac' : 'make -f make_mac.mak',
            \ 'linux' : 'make',
            \ 'unix' : 'gmake',
        \ }
    \ })

    call neobundle#untap()
endif

NeoBundleLazy 'Quramy/tsuquyomi', { 'depends': 'Shougo/vimproc.vim' }
if neobundle#tap('tsuquyomi')
    call neobundle#config({
        \ 'autoload': {
            \ 'filetypes': 'typescript'
        \ }
    \ })

    call neobundle#untap()
endif

NeoBundleLazy 'leafgarland/typescript-vim'
if neobundle#tap('typescript-vim')
    call neobundle#config({
        \ 'autoload': {
            \ 'filename_patterns': '.*\.ts',
            \ 'on_source': 'vim-markdown'
        \ }
    \ })

    function! neobundle#tapped.hooks.on_post_source(bundle)
        call neobundle#call_hook('on_post_source_typescript')
    endfunction

    call neobundle#untap()
endif

NeoBundle 'open-browser.vim'
if neobundle#tap('open-browser.vim')
    call neobundle#untap()
endif

call neobundle#end()
filetype plugin indent on
NeoBundleCheck

