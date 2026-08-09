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

    " 隠す対象は比較先の revision によらない。マーカーから読み取ると
    " レビューモードで巻き添えになるので、git に直接聞く。
    let s:ignored_paths = {}

    function! s:RefreshIgnoredPaths(root)
        let s:ignored_paths = {}
        let l:relatives = systemlist('git -C ' . shellescape(a:root)
                    \ . ' ls-files --others --ignored --exclude-standard --directory')
        if v:shell_error != 0
            return
        endif

        for l:relative in l:relatives
            let s:ignored_paths[a:root . '/' . substitute(l:relative, '/$', '', '')] = 1
        endfor
    endfunction

    function! MyFilter(params)
        return has_key(s:ignored_paths, a:params['path'].str())
    endfunction

    function! NERDTreeRefreshRootWithIgnored()
        call s:RefreshIgnoredPaths(b:NERDTree.root.path.str())
        NERDTreeRefreshRoot
        execute 'NERDTreeGitStatusDiffRef ' . get(g:, 'NERDTreeGitStatusDiffRef', '')
    endfunction

    autocmd! VimEnter * call NERDTreeAddPathFilter('MyFilter')

    augroup NerdtreeIgnoredPaths
        autocmd!
        autocmd User NERDTreeInit,NERDTreeNewRoot
                    \ call s:RefreshIgnoredPaths(b:NERDTree.root.path.str())
        autocmd VimEnter * call NERDTreeAddKeyMap({
            \ 'key': g:NERDTreeMapRefreshRoot,
            \ 'scope': 'all',
            \ 'callback': 'NERDTreeRefreshRootWithIgnored',
            \ 'override': 1 })
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
