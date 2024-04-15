set encoding=utf-8
scriptencoding utf-8

for s:src in split(glob('~/.vimrc.d/*.vim'), '\n')
    execute 'source ' . s:src
endfor

let s:local_rc = expand('~/.vimrc.local')
if filereadable(s:local_rc)
    execute 'source ' . s:local_rc
endif

