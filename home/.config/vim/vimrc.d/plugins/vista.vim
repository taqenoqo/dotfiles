Plug 'liuchengxu/vista.vim'

    let g:vista_default_executive = "coc"
    let g:vista_enable_markdown_extension = 0
    let g:vista_sidebar_width = 40
    let g:vista#renderer#enable_icon = 1
    let g:vista#renderer#icons = {
      \ 'func': "𝑓",
      \ 'function': "𝑓",
      \ 'functions': "𝑓",
      \ 'var': "𝑥",
      \ 'variable': "𝑥",
      \ 'variables': "𝑥",
      \ 'const': "𝑥",
      \ 'constant': "𝑥",
      \ 'constructor': "𝑓",
      \ 'method': "𝑓",
      \ 'package': "ℙ",
      \ 'packages': "ℙ",
      \ 'enum': "𝔼",
      \ 'enummember': "𝑚",
      \ 'enumerator': "𝑒",
      \ 'module': "𝕄",
      \ 'modules': "𝕄",
      \ 'type': "𝕋",
      \ 'typedef': "𝕋",
      \ 'types': "𝕋",
      \ 'field': "𝑥",
      \ 'fields': "𝑥",
      \ 'macro': "ℳ",
      \ 'macros': "ℳ",
      \ 'map': "𝓂",
      \ 'class': "ℂ",
      \ 'augroup': "𝔸",
      \ 'struct': "𝕊",
      \ 'union': "𝕌",
      \ 'member': "𝑚",
      \ 'target': "𝓉",
      \ 'property': "𝑥",
      \ 'interface': "𝕀",
      \ 'namespace': "ℕ",
      \ 'subroutine': "𝑠",
      \ 'implementation': "𝐼",
      \ 'typeParameter': "𝑡",
      \ 'default': "+"
    \}

    hi VistaIcon ctermfg=198 cterm=bold
    hi link VistaLineNr SpecialKey

    augroup VistaAutoStart
        autocmd!
        autocmd StdinReadPre * let s:exists_std_in = 1
        autocmd User CocNvimInit call s:vista_auto_start()
    augroup END

    function! s:vista_auto_start()
        if argc() == 0 && !exists("s:exists_std_in")
            Vista coc
        endif
    endfunction
