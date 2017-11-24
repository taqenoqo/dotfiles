if has('vim_starting')
    set runtimepath+=~/.vim/bundle/neobundle.vim
endif
call neobundle#begin(expand('~/.vim/bundle/'))
NeoBundleFetch 'Shougo/neobundle.vim'

NeoBundle 'yonchu/accelerated-smooth-scroll'

NeoBundle 'sudo.vim'

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

NeoBundle 'TAK3N0K0/vim-indent-guides', 'right-align'
if neobundle#tap('vim-indent-guides')
    let g:indent_guides_enable_on_vim_startup = 1
    let g:indent_guides_guide_size = 1
    let g:indent_guides_auto_colors = 0
    let g:indent_guides_right_align = 1
    let g:indent_guides_default_mapping = 0

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

NeoBundle 'Konfekt/FastFold'

NeoBundleLazy 'Shougo/neocomplete'
if neobundle#tap('neocomplete')
    call neobundle#config({
        \ 'autoload': {
            \ 'insert': 1
        \ }
    \ })

    function! neobundle#tapped.hooks.on_source(bundle)
        let g:neocomplete#enable_at_startup = 1
        let g:neocomplete#enable_smart_case = 1
        let g:neocomplete#auto_completion_start_length = 1
        let g:neocomplete#enable_fuzzy_completion = 1
        let g:neocomplete#skip_auto_completion_time = '0.1'
        let g:neocomplete#use_vimproc = 1
        if !exists('g:neocomplete#sources#omni#input_patterns')
            let g:neocomplete#sources#omni#input_patterns = {}
        endif
        let g:neocomplete#sources#omni#input_patterns['php'] = '\w'
        if !exists('g:neocomplete#force_omni_input_patterns')
            let g:neocomplete#force_omni_input_patterns = {}
        endif
        let g:neocomplete#force_omni_input_patterns['ruby'] = '\w'

        inoremap <expr> <C-n> neocomplete#start_manual_complete()
        inoremap <expr> <S-TAB> pumvisible() ? "\<C-p>" : "\<S-TAB>"
        inoremap <expr> <C-h> neocomplete#smart_close_popup()."\<C-h>"
        inoremap <expr> <BS> neocomplete#smart_close_popup()."\<C-h>"
        inoremap <expr> <C-y> neocomplete#close_popup()
        inoremap <expr> <C-e> neocomplete#cancel_popup()
        inoremap <expr> <CR> <SID>cr_neocomplete()
        inoremap <expr> <TAB> <SID>tab_neocomplete()

        function! s:cr_neocomplete()
            return pumvisible() ? neocomplete#close_popup() : "\<Return>"
        endfunction

        function! s:tab_neocomplete()
            return pumvisible() ? "\<C-n>" : "\<TAB>"
        endfunction
    endfunction

    call neobundle#untap()
endif

NeoBundleLazy 'Shougo/neosnippet', { 'depends': 'Shougo/neocomplete' }
if neobundle#tap('neosnippet')
    call neobundle#config({
        \ 'autoload': {
            \ 'on_source': 'neocomplete'
        \ }
    \ })

    function! neobundle#tapped.hooks.on_source(bundle)
        let g:neosnippet#snippets_directory = '~/.vim/snippets/'
        let g:neosnippet#enable_preview = 1

        smap <expr><TAB> neosnippet#jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<Tab>"
        imap <expr> <CR> <SID>cr_neosnippet()
        imap <expr> <TAB> <SID>tab_neosnippet()

        function! s:cr_neosnippet()
            return pumvisible() && neosnippet#expandable() ? "\<Plug>(neosnippet_expand)" : s:cr_neocomplete()
        endfunction

        function! s:tab_neosnippet()
            return !pumvisible() && neosnippet#jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : s:tab_neocomplete()
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
        let g:quickrun_config['html'] = {
            \ 'outputter' : 'browser',
            \ 'command' : 'cat',
        \ }
        let g:quickrun_config['tex'] = {
            \ 'command': 'xelatex',
            \ 'outputter': 'error',
            \ 'outputter/error/success': 'null',
            \ 'outputter/error/error': 'buffer',
            \ 'exec': [
                \ '%c %o %a %s',
                \ 'open "%S:r.pdf"'
            \ ]
        \ }
        let g:quickrun_config['markdown'] = {
            \ 'type': 'pandoc',
            \ 'outputter': 'error',
            \ 'outputter/error/success': 'browser',
            \ 'outputter/error/error': 'buffer',
            \ 'cmdopt': '--from=markdown_strict' . 
                \ '+tex_math_dollars' .
                \ '+tex_math_double_backslash' .
                \ '+fenced_code_blocks' .
                \ '+fenced_code_attributes' .
                \ '+backtick_code_blocks' .
                \ '+definition_lists' .
                \ '+pipe_tables' .
                \ '+markdown_in_html_blocks' .
                \ ' --to=html5' .
                \ ' --template="$HOME/.pandoc/template.html"' .
                \ ' --mathjax="$HOME/.pandoc/dynload.js"' .
                \ ' --css="$HOME/.pandoc/style.css"' .
                \ ' --include-in-header="$HOME/.pandoc/mathjax_config.html"' .
                \ ' --self-contained'
                \ ,
        \ }
    endfunction

    call neobundle#untap()
endif

NeoBundleLazy 'TAK3N0K0/vim-markdown', 'my-custom'
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
        call add(g:markdown_fenced_languages, 'ocaml')
        call add(g:markdown_fenced_languages, 'javascript')
        call add(g:markdown_fenced_languages, 'r')
        call add(g:markdown_fenced_languages, 'sh')
        call add(g:markdown_fenced_languages, 'conf')
        call add(g:markdown_fenced_languages, 'pfmain')
        hi link markdownCodeDelimiter Delimiter
        hi link markdownListMarker Identifier
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

    function! neobundle#tapped.hooks.on_source(bundle)
        setlocal omnifunc=necoghc#omnifunc
        if !exists('g:neocomplete#force_omni_input_patterns')
            let g:neocomplete#force_omni_input_patterns = {}
        endif
        let g:neocomplete#force_omni_input_patterns['typescript'] = '\w'

        augroup typescript
            autocmd FileType typescript nmap <buffer> <Leader><Return> : <C-u>echo tsuquyomi#hint()<CR>
            autocmd FileType typescript nmap <buffer> <Leader>c <Plug>(TsuquyomiRenameSymbolC)
        augroup END
    endfunction

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
        if !exists('g:markdown_fenced_languages')
            let g:markdown_fenced_languages = []
        endif
        call add(g:markdown_fenced_languages, 'typescript')
    endfunction

    call neobundle#untap()
endif

NeoBundle 'open-browser.vim'
if neobundle#tap('open-browser.vim')
    call neobundle#untap()
endif

NeoBundleLazy 'mgrabovsky/coq.vim'
if neobundle#tap('coq.vim')
    call neobundle#config({
        \ 'autoload': {
            \ 'filename_patterns': '.*\.v'
        \ }
    \ })

    call neobundle#untap()
endif

NeoBundleLazy 'CoqIDE'
if neobundle#tap('CoqIDE')
    call neobundle#config({
        \ 'autoload': {
            \ 'filetypes': 'coq'
        \ }
    \ })

    function! neobundle#tapped.hooks.on_source(bundle)
        nmap <Leader><Enter> :CoqIDEToCursor<CR>
    endfunction

    call neobundle#untap()
endif

NeoBundleLazy 'adimit/prolog.vim'
if neobundle#tap('prolog.vim')
    call neobundle#config({
        \ 'autoload': {
            \ 'filename_patterns': '.*\.swi'
        \ }
    \ })

    augroup prolog
        autocmd BufNewFile,BufRead *.swi setfiletype prolog
    augroup END

    call neobundle#untap()
endif

NeoBundleLazy 'ujihisa/neco-ghc'
if neobundle#tap('neco-ghc')
    call neobundle#config({
        \ 'autoload': {
            \ 'filetypes': 'haskell'
        \ }
    \ })

    function! neobundle#tapped.hooks.on_source(bundle)
        setlocal omnifunc=necoghc#omnifunc
        let g:necoghc_enable_detailed_browse = 1
        let g:necoghc_use_stack = 1
    endfunction

    call neobundle#untap()
endif

NeoBundleLazy 'eagletmt/ghcmod-vim'
if neobundle#tap('ghcmod-vim')
    call neobundle#config({
        \ 'autoload': {
            \ 'filetypes': 'haskell'
        \ }
    \ })

    function! neobundle#tapped.hooks.on_source(bundle)
        noremap <Leader>h<Enter> :GhcModType!<CR>
        noremap <Leader>ht :GhcModType!<CR>
        noremap <Leader>hi :GhcModInfo!<CR>
        noremap <Leader>hl :GhcModLintAsync!<CR>
        noremap <Leader>hs :GhcModTypeInsert!<CR>
        noremap <Leader>hp :GhcModSplitFunCase!<CR>

        let l:old_cl = maparg("<C-L>", "n")
        let l:new_cl = ":GhcModTypeClear<CR>" . l:old_cl
        exec "noremap <silent> <C-L> " . l:new_cl

        function! s:haskell_set_autocmd()
            augroup haskell_error_check
                autocmd! * <buffer>
                autocmd BufWritePost <buffer> :GhcModCheckAsync
            augroup END
        endfunction

        augroup haskell_autocmd_setter
            autocmd!
            autocmd FileType haskell call s:haskell_set_autocmd()
        augroup END
    endfunction

    call neobundle#untap()
endif

NeoBundleLazy 'rking/ag.vim'
if neobundle#tap('ag.vim')
    call neobundle#config({
        \ 'autoload': {
            \ 'commands': 'Ag'
        \ }
    \ })

    call neobundle#untap()
endif

NeoBundleLazy 'taiansu/nerdtree-ag', { 'depends': ['scrooloose/nerdtree', 'rking/ag.vim'] }
if neobundle#tap('nerdtree-ag')
    call neobundle#config({
        \ 'autoload': {
            \ 'on_source': 'nerdtree'
        \ }
    \ })

    call neobundle#untap()
endif

NeoBundleLazy 'toyamarinyon/vim-swift'
if neobundle#tap('vim-swift')
    call neobundle#config({
        \ 'autoload': {
            \ 'filename_patterns': '.*\.swift',
            \ 'on_source': 'vim-markdown'
        \ }
    \ })

    function! neobundle#tapped.hooks.on_post_source(bundle)
        if !exists('g:markdown_fenced_languages')
            let g:markdown_fenced_languages = []
        endif
        call add(g:markdown_fenced_languages, 'swift')
    endfunction

    call neobundle#untap()
endif

NeoBundleLazy 'dag/vim2hs'
if neobundle#tap('vim2hs')
    call neobundle#config({
        \ 'autoload': {
            \ 'filename_patterns': ['.*\.hs', '.*\.hsc']
        \ }
    \ })

    function! neobundle#tapped.hooks.on_source(bundle)
        let g:haskell_conceal_wide = 0
        let g:haskell_conceal = 0
    endfunction

    call neobundle#untap()
endif

NeoBundle 'joom/latex-unicoder.vim'
if neobundle#tap('latex-unicoder.vim')
    let g:unicoder_cancel_normal = 1
    let g:unicoder_cancel_insert = 1
    let g:unicoder_cancel_visual = 1
    let g:unicoder_no_map = 1
    inoremap <C-u> <Esc>:call unicoder#start(1)<CR>
endif

NeoBundleLazy 'TAK3N0K0/tex-conceal.vim', 'my-custom'
if neobundle#tap('tex-conceal.vim')
    call neobundle#config({
        \ 'autoload': {
            \ 'filename_patterns': ['.*\.md', '.*\.tex']
        \ }
    \ })

    function! neobundle#tapped.hooks.on_source(bundle)
        hi clear Conceal
        set conceallevel=2
        let g:tex_conceal="abdgm"
    endfunction
endif

NeoBundle 'gtags.vim'
if neobundle#tap('tex-conceal.vim')
    nnoremap <Leader>g<Enter> :Gtags <C-r><C-w><CR>
    nnoremap <Leader>gr :Gtags -r <C-r><C-w><CR>
    nnoremap <Leader>gl :Gtags -f %<CR>
    nnoremap <Leader>gi :Gtags<CR>
    nnoremap <Leader>gn :cn<CR>
    nnoremap <Leader>gp :cp<CR>
endif

NeoBundle 'zebult/auto-gtags.vim'
if neobundle#tap('tex-conceal.vim')
    nnoremap <Leader>gg :GtagsCreate<CR>
    let g:auto_gtags = 1
endif

call neobundle#end()
filetype plugin indent on
NeoBundleCheck

