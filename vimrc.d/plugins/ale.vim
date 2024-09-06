Plug 'dense-analysis/ale'
let g:ale_fixers = {
    \ '*': ['remove_trailing_lines', 'trim_whitespace'],
    \ 'kotlin': ['ktlint'],
\}
"let g:ale_set_highlights = 1

highlight! link ALEVirtualTextError NonText
highlight! link ALEVirtualTextWarning NonText
highlight! link ALEVirtualTextInfo NonText
highlight! ALEErrorSign ctermfg=203
highlight! ALEWarningSign ctermfg=208
highlight! ALEInfoSign ctermfg=035
