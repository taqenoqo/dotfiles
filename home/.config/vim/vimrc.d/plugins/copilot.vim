Plug 'github/copilot.vim'

    let g:copilot_no_tab_map = v:true
    imap <silent><expr> <C-g><C-g> copilot#Accept("\<C-g>\<C-g>")
    imap <silent> <C-g><C-n> <Plug>(copilot-next)
    imap <silent> <C-g><C-p> <Plug>(copilot-previous)

    highlight! link CopilotSuggestion NonText

Plug 'DanBradbury/copilot-chat.vim'

    vmap <leader>ca <Plug>CopilotChatAddSelection
    nnoremap <leader>cc :CopilotChatToggle<CR>
    nnoremap <leader>cr :CopilotChatReset<CR>
    nnoremap <leader>cm :CopilotChatModels<CR>
