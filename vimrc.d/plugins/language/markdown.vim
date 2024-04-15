Plug 'taqenoqo/vim-markdown', { 'branch': 'tex-math-dollars' }

let g:markdown_fenced_tex = 1
let g:markdown_fenced_languages = [
    \ 'zsh',
    \ 'c',
    \ 'ruby',
    \ 'vim',
    \ 'java',
    \ 'haskell',
    \ 'ocaml',
    \ 'javascript',
    \ 'r',
    \ 'sh',
    \ 'conf',
    \ 'pfmain',
    \ 'perl',
    \ 'xml'
\ ]

hi link markdownCodeDelimiter Delimiter
hi link markdownListMarker Identifier

