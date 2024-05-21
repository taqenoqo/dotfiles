Plug 'dense-analysis/ale'
let g:ale_fixers = {
    \ '*': ['remove_trailing_lines', 'trim_whitespace'],
    \ 'kotlin': ['ktlint'],
\}
