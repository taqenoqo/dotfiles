Plug 'airblade/vim-gitgutter'

    let g:gitgutter_sign_priority = 5

Plug 'tpope/vim-fugitive'

    function! GitDiffFromInput()
        let l:input = input('Input rev to compare: ')
        if l:input == ''
            return
        endif
        execute 'Gvdiffsplit ' . l:input
    endfunction

    nmap <Leader>gc :Git commit<CR>
    nmap <Leader>gs :Git<CR>
    nmap <Leader>gd :Gvdiffsplit<CR>
    nmap <Leader>gD :call GitDiffFromInput()<CR>
    nmap <Leader>gl :GlLog<CR>
    nmap <Leader>ga :Gwrite<CR>
    nmap <Leader>gb :Git blame<CR>
