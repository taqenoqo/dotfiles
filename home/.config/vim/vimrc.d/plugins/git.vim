Plug 'tpope/vim-fugitive'

    function! GitDiffFromInput()
        let l:input = input('Input rev to compare: ')
        if l:input == ''
            return
        endif
        execute 'Gvdiffsplit ' . l:input
    endfunction

    function! GitDiffFromMergeBase(rev)
        let l:merge_base = systemlist('git merge-base HEAD ' . shellescape(a:rev))
        if v:shell_error != 0 || empty(l:merge_base)
            echoerr 'Failed to resolve merge-base for ' . a:rev
            return
        endif
        execute 'Gvdiffsplit ' . l:merge_base[0]
    endfunction

    function! GitDiffFromMergeBaseInput()
        let l:input = input('Input rev to compare from merge-base: ')
        if l:input == ''
            return
        endif
        call GitDiffFromMergeBase(l:input)
    endfunction

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

    function! GitSetReviewBase()
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

    function! GitDiffFromReviewRef()
        execute 'Gvdiffsplit ' . get(g:, 'NERDTreeGitStatusDiffRef', '')
    endfunction

    nmap <Leader>gc :Git commit<CR>
    nmap <Leader>gs :Git<CR>
    nmap <Leader>gd :call GitDiffFromReviewRef()<CR>
    nmap <Leader>gD :call GitDiffFromInput()<CR>
    nmap <Leader>gM :call GitDiffFromMergeBaseInput()<CR>
    nmap <Leader>gr :call GitSetReviewBase()<CR>
    nmap <Leader>gl :GlLog<CR>
    nmap <Leader>ga :Gwrite<CR>
    nmap <Leader>gb :Git blame<CR>
