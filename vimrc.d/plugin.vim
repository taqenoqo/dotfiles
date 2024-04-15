autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

call plug#begin()

for s:src in split(glob(expand('<sfile>:p:h') . '/plugins/*.vim'), '\n')
    execute 'source ' . s:src
endfor

call plug#end()
