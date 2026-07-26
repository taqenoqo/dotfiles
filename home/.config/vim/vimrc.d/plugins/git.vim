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

    function! GitDiffFromReviewRef()
        execute 'Gvdiffsplit ' . get(g:, 'NERDTreeGitStatusDiffRef', '')
    endfunction

    nmap <Leader>gc :Git commit<CR>
    nmap <Leader>gs :Git<CR>
    nmap <Leader>gd :call GitDiffFromReviewRef()<CR>
    nmap <Leader>gD :call GitDiffFromInput()<CR>
    nmap <Leader>gM :call GitDiffFromMergeBaseInput()<CR>
    nmap <Leader>gl :GlLog<CR>
    nmap <Leader>ga :Gwrite<CR>
    nmap <Leader>gb :Git blame<CR>
