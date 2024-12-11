Plug 'github/copilot.vim'

    let g:copilot_no_tab_map = v:true
    imap <silent><expr> <C-g><C-g> copilot#Accept("\<C-g>\<C-g>")
    imap <silent> <C-g><C-n> <Plug>(copilot-next)
    imap <silent> <C-g><C-p> <Plug>(copilot-previous)

    highlight! link CopilotSuggestion NonText
