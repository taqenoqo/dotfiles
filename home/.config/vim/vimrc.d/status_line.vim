augroup emoticon_status_line
    autocmd!
    autocmd BufEnter * let b:statusline_face = '\|ﾟーﾟ)ﾉｨｮｩ'
    autocmd CursorMoved * let b:statusline_face = '(*ﾟーﾟ)'
    autocmd InsertLeave * let b:statusline_face = 'ε＝(ﾉ*ﾟーﾟ)ﾉ'
    autocmd InsertEnter * let b:statusline_face = '(σ*ﾟーﾟ)σ'
    autocmd BufWritePost * let b:statusline_face = '(*ﾟーﾟ*)♪'
augroup END

function GetCursorSyntax()
    return synIDattr(synID(line('.'), col('.'), 0), 'name')
endfunction

function GetVisualSelectionCount()
    if mode() !~# '^[vVsS]' && mode() !=# "\<C-V>" && mode() !=# "\<C-S>"
        return ''
    endif
    return printf('%d chars', get(wordcount(), 'visual_chars', 0))
endfunction

function UpdateStatusLine(...)
    let l:left = '\ %t%m\ %y[%{&fenc},\ %{&ff}]\ %r%h%w'
    if exists('*coc#status')
        let l:left = l:left . '\ %{coc#status()}'
    endif
    let l:face = get(b:, 'statusline_face', '\|ーﾟ)')
    let l:right = '%{GetVisualSelectionCount()}\ %{GetCursorSyntax()}\ (%p%%)\ %l,%v\ =\ 0x%B\ ' . l:face . '\ '
    exec 'setlocal statusline=' . l:left . '%=' . l:right
endfunction

function InitStatusLine()
    let b:statusline_face=''
    call timer_start(100, function("UpdateStatusLine"), {'repeat': -1})
endfunction

call InitStatusLine()
