augroup FaceEventHook
    autocmd!
    autocmd InsertLeave * call s:changeFace('(*ﾟーﾟ)♪\ ')
    autocmd CursorMoved * call s:changeFace('(*ﾟーﾟ)')
    autocmd InsertEnter * call s:changeFace('(*ﾟД\ ﾟ)')
    autocmd BufWritePost * call s:changeFace('(*^ーﾟ)')
    autocmd CursorHold * call s:changeFace('ｃ⌒っ*ﾟーﾟ)っ')
augroup END
let s:oldFace = ""
function GetSyntaxType()
    return synIDattr(synID(line('.'), col('.'), 0), 'name')
endfunction
function s:changeFace(face)
    if a:face == s:oldFace
        return
    endif
    silent let l:line = 'set statusline=\ ' . a:face
    silent let l:line .= '\ %<%l,%c=%B[%{GetSyntaxType()}]%=%n:%p%%\ %m%r%h%w%y\ %t\ [%{&fenc}][%{&ff}]\ '
    silent exec l:line
    silent let s:oldFace = a:face
endfunction

