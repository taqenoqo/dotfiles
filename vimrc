set encoding=utf-8
scriptencoding utf-8

for src in split(glob('~/.vimrc.d/*.vim'), '\n')
    execute 'source ' . src
endfor

