setlocal spell

function! s:recent_commit_subjects() abort
  let l:subjects = systemlist([
        \ 'git',
        \ '--no-pager',
        \ 'log',
        \ '--first-parent',
        \ '--no-merges',
        \ '--format=%s',
        \ '--max-count=20',
        \ ])
  if v:shell_error != 0
    return []
  endif

  return filter(l:subjects, '!empty(v:val)')
endfunction

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

  let l:recent_subjects = s:recent_commit_subjects()
  let l:message = "以下の staged diff に対するコミット件名を 1 行だけ書いてください。\n"
        \ .. "候補や説明は不要です。\n"
        \ .. "最近のコミット件名があれば、言語・語調・粒度・表記の雰囲気を合わせてください。\n\n"

  if !empty(l:recent_subjects)
    let l:message ..= "最近のコミット件名:\n"
          \ .. join(map(copy(l:recent_subjects), '"- " .. v:val'), "\n")
          \ .. "\n\n"
  endif

  let l:message ..= "staged diff:\n"
        \ .. join(l:diff_lines, "\n")

  call copilot_chat#OpenChat()
  call copilot_chat#buffer#AppendMessage(split(l:message, "\n"))
  call copilot_chat#api#AsyncRequest([{'content': l:message, 'role': 'user'}], [])
endfunction

command! -buffer CopilotCommitMessage call s:ask_commit_message()
nnoremap <silent><buffer> <leader>cg :<C-u>CopilotCommitMessage<CR>
