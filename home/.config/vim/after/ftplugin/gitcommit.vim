setlocal spell

function! s:ask_commit_message() abort
  let l:diff_lines = systemlist([
        \ 'git',
        \ '--no-pager',
        \ 'diff',
        \ '--cached',
        \ '--no-ext-diff',
        \ '--no-color',
        \ '--stat',
        \ '--patch',
        \ '--unified=3',
        \ ])
  if v:shell_error != 0 || empty(l:diff_lines)
    echohl WarningMsg
    echom 'staged diff が空です。先に git add してください。'
    echohl None
    return
  endif

  let l:message = "以下の staged diff に対するコミット件名を英語で 1 行だけ書いてください。\n"
        \ .. "候補や説明は不要です。\n\n"
        \ .. join(l:diff_lines, "\n")

  call copilot_chat#OpenChat()
  call copilot_chat#buffer#AppendMessage(split(l:message, "\n"))
  call copilot_chat#api#AsyncRequest([{'content': l:message, 'role': 'user'}], [])
endfunction

command! -buffer CopilotCommitMessage call s:ask_commit_message()
nnoremap <silent><buffer> <leader>cg :<C-u>CopilotCommitMessage<CR>
