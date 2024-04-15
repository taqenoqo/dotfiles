for s:src in split(glob(expand('<sfile>:p:h') . '/language/*.vim'), '\n')
    execute 'source ' . s:src
endfor
