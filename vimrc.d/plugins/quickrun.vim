Plug 'thinca/vim-quickrun'

    let g:quickrun_config = {}
    let g:quickrun_config['html'] = {
        \ 'outputter' : 'browser',
        \ 'command' : 'cat',
    \ }
    let g:quickrun_config['tex'] = {
        \ 'command': 'latexmk',
        \ 'cmdopt': '-pv',
        \ 'outputter': 'error',
        \ 'outputter/error/success': 'null',
        \ 'outputter/error/error': 'buffer',
        \ 'exec': [
            \ '%c %o %a %s'
        \ ]
    \ }
    let s:pandoc_opt =
        \ '--from=markdown_strict' .
        \ '+tex_math_dollars' .
        \ '+tex_math_double_backslash' .
        \ '+fenced_code_blocks' .
        \ '+backtick_code_blocks' .
        \ '+definition_lists' .
        \ '+pipe_tables' .
        \ '+markdown_in_html_blocks' .
        \ '+footnotes' .
        \ '+implicit_figures' .
        \ '+inline_notes' .
        \ '+header_attributes' .
        \ '+fenced_code_attributes' .
        \ '+inline_code_attributes' .
        \ '+link_attributes' .
        \ '+fenced_divs' .
        \ '+bracketed_spans' .
        \ ' --to=html5' .
        \ ' --template="$HOME/.pandoc/template.html"' .
        \ ' --mathjax="$HOME/.pandoc/dynload.js"' .
        \ ' --css="$HOME/.pandoc/style.css"' .
        \ ' --include-in-header="$HOME/.pandoc/mathjax_config.html"' .
        \ ' --self-contained' .
        \ ' --standalone' .
        \ ' --variable=pagetitle:%{expand("%:t")}'
    let s:pandoc_pre_exec = '%c %o -t json %a %s | '
    let s:pandoc_post_exec = '%c %o -f json %a'
    let s:pandoc_filter = ''

    let s:pandoc_ditaa_filter_cmd = 'pandoc-ditaa-filter'
    let s:pandoc_ditaa_filter_opts = '--ditaa-opts="-E -S --svg" --img-ext="svg"'
    if executable(s:pandoc_ditaa_filter_cmd)
        let s:pandoc_filter = s:pandoc_filter . s:pandoc_ditaa_filter_cmd . ' ' . s:pandoc_ditaa_filter_opts . ' | '
    endif

    if executable('mermaid-filter')
        let s:pandoc_filter = s:pandoc_filter . 'mermaid-filter | '
    endif

    let s:pandoc_exec = s:pandoc_pre_exec . s:pandoc_filter . s:pandoc_post_exec
    let g:quickrun_config['markdown'] = {
        \ 'type': 'pandoc',
        \ 'outputter': 'error',
        \ 'outputter/error/success': 'browser',
        \ 'outputter/error/error': 'buffer',
        \ 'cmdopt': s:pandoc_opt,
        \ 'exec': [
            \ s:pandoc_exec
        \ ]
    \ }

    nmap <leader>r <Plug>(quickrun)

