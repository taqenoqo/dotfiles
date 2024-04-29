Plug 'airblade/vim-gitgutter'

    let g:gitgutter_sign_priority = 5

Plug 'tpope/vim-fugitive'

    nmap <Leader>gc :Git commit<CR>
    nmap <Leader>gs :Git<CR>
    nmap <Leader>gd :Git diff<CR>
    nmap <Leader>gl :Git log --paginate<CR>
    nmap <Leader>ga :Git add<CR>
    nmap <Leader>gb :Git blame<CR>
