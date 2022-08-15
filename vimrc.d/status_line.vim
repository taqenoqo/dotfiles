augroup emoticon_status_line
    autocmd!
    autocmd BufEnter * let b:statusline_face = '\|ﾟーﾟ)ﾉｨｮｩ'
    autocmd CursorMoved * let b:statusline_face = '\|ﾟーﾟ)ﾉｨｮｩ'
    autocmd InsertLeave * let b:statusline_face = 'ε＝(ﾉ*ﾟーﾟ)ﾉ'
    autocmd InsertEnter * let b:statusline_face = '(σ*ﾟーﾟ)σ'
    autocmd BufWritePost * let b:statusline_face = '(*ﾟーﾟ*)♪'
augroup END

function GetCursorSyntax()
    return synIDattr(synID(line('.'), col('.'), 0), 'name')
endfunction

function UpdateStatusLine(...)
    let l:left = '\ %t%m\ %y[%{&fenc},\ %{&ff}]\ %r%h%w\ %{coc#status()}'
    let l:right = '%{GetCursorSyntax()}\ (%p%%)\ %l,%c\ =\ 0x%B\ ' . b:statusline_face . '\ '
    exec 'setlocal statusline=' . l:left . '%=' . l:right
endfunction

function InitStatusLine()
    let b:statusline_face=''
    call timer_start(100, function("UpdateStatusLine"), {'repeat': -1})
endfunction

call InitStatusLine()
