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

    " origin/HEAD は既定ブランチ (main / master) を指すので、ブランチ名を判別せずに済む。
    let s:review_rev = 'origin/HEAD...'

    function s:ApplyReviewBase(rev)
        let l:base = empty(a:rev) ? '' : s:ResolveReviewBase(a:rev)
        if !empty(a:rev) && empty(l:base)
            return 0
        endif

        execute 'NERDTreeGitStatusDiffRef ' . l:base
        call coc#config('git.diffRevision', l:base)
        silent! CocCommand git.refresh
        return 1
    endfunction

    function GitSetReviewBase()
        let l:rev = input('Input rev to review: ')
        if s:ApplyReviewBase(l:rev) && !empty(l:rev)
            let s:review_rev = l:rev
        endif
    endfunction

    " 解決済みのコミットではなく入力を覚えておき、切り替えのたびに解決し直す。
    " HEAD が進んでも merge-base が追従するため。
    function GitToggleReviewBase()
        call s:ApplyReviewBase(empty(get(g:, 'NERDTreeGitStatusDiffRef', '')) ? s:review_rev : '')
    endfunction

    function! GitDiffFromReviewRef()
        execute 'Gvdiffsplit ' . get(g:, 'NERDTreeGitStatusDiffRef', '')
    endfunction

    nmap <Leader>gc :Git commit<CR>
    nmap <Leader>gs :Git<CR>
    nmap <Leader>gd :call GitDiffFromReviewRef()<CR>
    nmap <Leader>gD :call GitDiffFromInput()<CR>
    nmap <Leader>gM :call GitDiffFromMergeBaseInput()<CR>
    nmap <Leader>gr :call GitToggleReviewBase()<CR>
    nmap <Leader>gR :call GitSetReviewBase()<CR>
    nmap <Leader>gl :GlLog<CR>
    nmap <Leader>ga :Gwrite<CR>
    nmap <Leader>gb :Git blame<CR>
