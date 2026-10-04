Plug 'liuchengxu/vista.vim'

    let g:vista_default_executive = "coc"
    let g:vista_enable_markdown_extension = 0
    let g:vista_sidebar_width = 30
    let g:vista_stay_on_open = 0
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

    function s:OpenVistaWhenReady(timer) abort
        if !get(g:, 'vista_auto_open', 1) || vista#sidebar#IsOpen()
            call timer_stop(a:timer)
        elseif get(g:, 'coc_service_initialized', 0) && !empty(CocAction('documentSymbols'))
            call timer_stop(a:timer)
            Vista coc
        endif
    endfunction

    let s:timer = 0

    " 言語サーバは最初のファイルを開いてから起動するので、シンボルを返せるまで待つ
    function s:WaitForSymbols() abort
        call timer_stop(s:timer)
        let s:timer = timer_start(100, function('s:OpenVistaWhenReady'), {'repeat': 50})
    endfunction

    augroup VistaAutoStart
        autocmd!
        autocmd BufWinEnter,TabEnter * call s:WaitForSymbols()
    augroup END
