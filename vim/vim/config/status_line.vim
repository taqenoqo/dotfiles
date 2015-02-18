augroup emoticon_status_line
    autocmd!
    autocmd BufEnter * call s:changeFace('\|ﾟーﾟ)ﾉｨｮｩ')
    autocmd CursorMoved * call s:changeFace('(*ﾟーﾟ)')
    autocmd InsertLeave * call s:changeFace('ε＝(ﾉ*ﾟーﾟ)ﾉ')
    autocmd InsertEnter * call s:changeFace('(σ* ﾟーﾟ)σ')
    autocmd BufWritePost * call s:changeFace('(*ﾟーﾟ*)♪')
    autocmd CursorHold * call s:changeFace('ｃ⌒っ*ﾟーﾟ)っ')
augroup END

function GetSyntaxType()
    return synIDattr(synID(line('.'), col('.'), 0), 'name')
endfunction

function s:changeFace(face)
    let l:left = '\ %t%m\ %y[%{&fenc},\ %{&ff}]\ %r%h%w'
    let l:right = '%{GetSyntaxType()}\ (%p%%)\ %l,%c\ =\ 0x%B\ ' . a:face . '\ '
    exec 'setlocal statusline=' . l:left . '%=' . l:right
endfunction

