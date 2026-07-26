Plug 'scrooloose/nerdtree'

    let g:NERDTreeIgnore = ['^\.DS_Store$[[file]]', '\~$']
    let g:NERDTreeWinSize = 35
    let g:NERDTreeShowHidden = 1
    let g:NERDTreeMinimalUI = 1
    let g:NERDTreeAutoDeleteBuffer = 1
    
    augroup NerdtreeSettings
        autocmd!
        autocmd FileType nerdtree setlocal signcolumn=no
    augroup END

Plug 'rking/ag.vim'

Plug 'taiansu/nerdtree-ag'

Plug 'taqenoqo/nerdtree-git-plugin'

    let g:NERDTreeGitStatusShowIgnored = 1
    let g:NERDTreeGitStatusConcealBrackets = 1
    let g:NERDTreeGitStatusConcealFormat = '%s '
    let g:NERDTreeGitStatusAlignIfConceal = 1
    let g:NERDTreeGitStatusIndicatorMapCustom = {
        \ "Untracked" : "!",
        \ "Modified"  : "*",
        \ "Dirty"     : "*",
        \ "Staged"    : "+",
        \ "Renamed"   : ">",
        \ "Unmerged"  : "!",
        \ "Deleted"   : "X",
        \ "Clean"     : "-",
        \ 'Ignored'   : "-",
        \ "Unknown"   : "?"
    \ } 

    hi NERDTreeFlags ctermfg=249
    hi NERDTreeGitStatusUntracked ctermfg=206
    hi NERDTreeGitStatusModified ctermfg=208
    hi NERDTreeGitStatusDirty ctermfg=208
    hi NERDTreeGitStatusStaged ctermfg=077
    hi NERDTreeGitStatusRenamed ctermfg=69
    hi NERDTreeGitStatusUnmerged ctermfg=206
    hi NERDTreeGitStatusStaged ctermfg=077
    hi NERDTreeGitStatusDeleted ctermfg=197
    hi NERDTreeGitStatusClean ctermfg=249
    hi NERDTreeGitStatusIgnored ctermfg=249
    hi NERDTreeGitStatusUnknown ctermfg=249

    function! MyFilter(params)
        let l:flags = a:params['path'].flagSet._flags
        if !has_key(l:flags, 'git')
            return v:true
        endif
        let l:substituted = printf(g:NERDTreeGitStatusConcealFormat , g:NERDTreeGitStatusIndicatorMapCustom['Ignored'])
        let l:index = index(l:flags['git'], l:substituted)
        return l:index != -1
    endfunction

    autocmd! VimEnter * call NERDTreeAddPathFilter('MyFilter')

    " coc-git は 'git show <rev>:<path>' でファイルを取るため単一コミットしか解釈できない。
    " 渡す先ごとに基準がずれないよう、入力をここで 1 つのコミットに解決しておく。
    function! s:ResolveReviewBase(rev)
        if a:rev =~# '\.\.\.'
            let l:sides = map(split(a:rev, '\.\.\.', 1), 'empty(v:val) ? "HEAD" : v:val')
            let l:cmd = 'git merge-base ' . shellescape(l:sides[0]) . ' ' . shellescape(l:sides[1])
        else
            let l:cmd = 'git rev-parse --verify ' . shellescape(a:rev)
        endif

        let l:resolved = systemlist(l:cmd)
        if v:shell_error != 0 || empty(l:resolved)
            echoerr 'Failed to resolve revision: ' . a:rev
            return ''
        endif
        return l:resolved[0]
    endfunction

    function! NERDTreeSetDiffRef()
        let l:rev = input('Input rev to review: ')
        if !empty(l:rev)
            let l:rev = s:ResolveReviewBase(l:rev)
            if empty(l:rev)
                return
            endif
        endif

        execute 'NERDTreeGitStatusDiffRef ' . l:rev
        call coc#config('git.diffRevision', l:rev)
        silent! CocCommand git.refresh
    endfunction

    augroup NerdtreeGitDiffRef
        autocmd!
        autocmd VimEnter * call NERDTreeAddKeyMap({
            \ 'key': 'gr',
            \ 'scope': 'all',
            \ 'callback': 'NERDTreeSetDiffRef',
            \ 'quickhelpText': 'Set review base rev' })
    augroup END

Plug 'jistr/vim-nerdtree-tabs'

    function! s:nerdtree_auto_start()
        if argc() == 0 && !exists("s:exists_std_in")
            let g:nerdtree_tabs_open_on_console_startup = 1
        endif
    endfunction

    let s:closing_sidebar_tab = 0

    function! s:is_sidebar_tab()
        let l:sidebar_filetypes = ['nerdtree', 'vista', 'vista_kind', 'copilot_chat']
        let l:has_sidebar = 0

        for l:bufnr in tabpagebuflist()
            let l:filetype = getbufvar(l:bufnr, '&filetype')
            if index(l:sidebar_filetypes, l:filetype) == -1
                return 0
            endif
            let l:has_sidebar = 1
        endfor

        return l:has_sidebar
    endfunction

    function! s:close_sidebar_tab()
        if !s:is_sidebar_tab()
            return
        endif

        let s:closing_sidebar_tab = 1
        try
            if tabpagenr('$') <= 1
                qall
            else
                tabclose
            endif
        finally
            let s:closing_sidebar_tab = 0
        endtry
    endfunction

    function! s:request_sidebar_tab_close()
        if s:closing_sidebar_tab
            return
        endif

        let t:sidebar_tab_close_requested = 1
    endfunction

    function! s:close_requested_sidebar_tab()
        if !get(t:, 'sidebar_tab_close_requested', 0)
            return
        endif

        unlet t:sidebar_tab_close_requested
        call s:close_sidebar_tab()
    endfunction

    augroup NerdtreeAutoStart
        autocmd!
        autocmd StdinReadPre * let s:exists_std_in = 1
        autocmd VimEnter * call s:nerdtree_auto_start()
    augroup END

    augroup NerdtreeSidebarOnlyTabClose
        autocmd!
        autocmd WinClosed * call s:request_sidebar_tab_close()
        autocmd SafeState * call s:close_requested_sidebar_tab()
    augroup END
