Plug 'dense-analysis/ale'

    let g:ale_fixers = {
        \ '*': ['remove_trailing_lines', 'trim_whitespace'],
        \ 'kotlin': ['ktlint'],
        \ 'typescript': ['biome', 'prettier'],
    \}
    let g:ale_linter_aliases = {
        \ 'bash': ['sh'],
        \ 'zsh': ['sh'],
    \}

    let g:ale_floating_preview = 1
    let g:ale_markdown_markdownlint_executable = 'markdownlint-cli2'
    let g:ale_markdown_markdownlint_options = '--config ~/.markdownlint.json'
    let g:ale_virtualtext_column = 40
    let g:ale_virtualtext_maxcolumn = 80

    highlight! link ALEVirtualTextError NonText
    highlight! link ALEVirtualTextWarning NonText
    highlight! link ALEVirtualTextInfo NonText
    highlight! ALEErrorSign ctermfg=203
    highlight! ALEWarningSign ctermfg=208
    highlight! ALEInfoSign ctermfg=035
    highlight! link ALEError Error
    highlight! link ALEWarning Warning
    highlight! link ALEInfo Info

    nmap <leader>f :ALEFix<CR>
    nmap <leader>e :ALEDetail<CR>

    function! s:popupFilter(winid, key) abort
        if a:key ==# 'y'
            call s:CopyError()
            call popup_close(a:winid)
            return 1
        endif
        return 0
    endfunction

    function! s:CopyError() abort
        let l:buffer = bufnr('')
        if ale#ShouldDoNothing(l:buffer)
            return v:false
        endif
        let [l:info, l:loc] = ale#util#FindItemAtCursor(l:buffer)
        if empty(l:loc)
            return v:false
        endif
        let @" = l:loc['text']
        return v:true
    endfunction

    let g:ale_floating_preview_popup_opts = {
        \ 'maxwidth': 80,
        \ 'borderchars': ['─', '│', '─', '│', '╭', '╮', '╯', '╰'],
        \ 'zindex': 100,
        \ 'filter': function('s:popupFilter'),
        \ 'filtermode': 'n',
    \}
