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
        \ 'exec': [ '%c %o %a %s' ]
    \ }
    let g:quickrun_config['plantuml'] = {
        \ 'command': 'plantuml',
        \ 'cmdopt': '-svg -p',
        \ 'outputter': 'error',
        \ 'outputter/error/success': 'browser',
        \ 'outputter/error/error': 'buffer',
        \ 'outputter/browser/name': '%{tempname()}.svg',
        \ 'exec': [ '%c %o %a <%s' ]
    \ }
    let g:quickrun_config['markdown'] = {
        \ 'type': 'md2html',
        \ 'outputter': 'error',
        \ 'outputter/error/success': 'browser',
        \ 'outputter/error/error': 'buffer',
    \ }

    let g:quickrun_config['marp'] = {
        \ 'command': 'marp',
        \ 'cmdopt': '--preview --theme ' . shellescape(expand('$XDG_CONFIG_HOME/marp/themes/my-theme.css')),
        \ 'outputter': 'error',
        \ 'outputter/error/success': 'null',
        \ 'outputter/error/error': 'buffer',
        \ 'exec': '%c %o %s'
    \ }

    nmap <leader>r <Plug>(quickrun)
