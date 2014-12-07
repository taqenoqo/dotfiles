augroup EmoticonStatusLine
    autocmd!
    autocmd InsertLeave * call s:changeFace('(*ﾟーﾟ)♪\ ')
    autocmd CursorMoved * call s:changeFace('(*ﾟーﾟ)')
    autocmd InsertEnter * call s:changeFace('(*ﾟД\ ﾟ)')
    autocmd BufWritePost * call s:changeFace('(*^ーﾟ)')
    autocmd CursorHold * call s:changeFace('ｃ⌒っ*ﾟーﾟ)っ')
augroup END

let s:oldFace = ''
function GetSyntaxType()
    return synIDattr(synID(line('.'), col('.'), 0), 'name')
endfunction

function s:changeFace(face)
    if s:oldFace == a:face
        return
    endif
    silent let l:line = 'setlocal statusline=\ %t%m\ %y[%{&fenc},\ %{&ff}]\ %r%h%w%=%{GetSyntaxType()}\ (%p%%)\ %l,%c\ =\ 0x%B\ ' . a:face . '\ '
    silent exec l:line
    silent let s:oldFace = a:face
endfunction

