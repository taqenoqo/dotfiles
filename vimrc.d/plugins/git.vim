Plug 'airblade/vim-gitgutter'

    let g:gitgutter_sign_priority = 5

Plug 'tpope/vim-fugitive'

    nmap <Leader>gc :Git commit<CR>
    nmap <Leader>gs :Git<CR>
    nmap <Leader>gd :Gvdiffsplit<CR>
    nmap <Leader>gl :GlLog<CR>
    nmap <Leader>ga :Gwrite<CR>
    nmap <Leader>gb :Git blame<CR>
