setlocal spell

command! -buffer CopilotCommitMessage call CopilotCommitMessage()
nnoremap <silent><buffer> <leader>cg :<C-u>CopilotCommitMessage<CR>
