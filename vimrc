let s:SETTINGS_DIR = '$HOME/.vim/settings'
let s:SETTINGS_EXTENSION = '.vim'

function s:loadSettings()
    let files = split(glob(s:SETTINGS_DIR . '/*' . s:SETTINGS_EXTENSION), '\n')
    for f in files
        if filereadable(f)
            execute 'source ' . f
        endif
    endfor
endfunction

call s:loadSettings()

