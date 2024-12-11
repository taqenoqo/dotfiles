function s:InstallPluginIfChanged()
    let plugs = values(g:plugs)
    if len(filter(plugs, { -> !isdirectory(v:val.dir) })) > 0
        PlugInstall --sync
        source $MYVIMRC
    endif
endfunction

augroup plugin_loading
    autocmd!
    autocmd VimEnter * call s:InstallPluginIfChanged()
augroup END

call plug#begin()

for s:src in split(glob(expand('<sfile>:p:h') . '/plugins/*.vim'), '\n')
    execute 'source ' . s:src
endfor

call plug#end()
