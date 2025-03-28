Plug 'dense-analysis/ale'
let g:ale_fixers = {
    \ '*': ['remove_trailing_lines', 'trim_whitespace'],
    \ 'kotlin': ['ktlint'],
    \ 'typescript': ['biome', 'prettier'],
\}
let g:ale_linter_aliases = {
    \ 'bash': ['sh'],
    \ 'zsh': ['sh'],
\ }
let g:ale_set_highlights = 0
let g:ale_floating_preview = 1
let g:ale_markdown_markdownlint_executable = 'markdownlint-cli2'
let g:ale_markdown_markdownlint_options = '--config ~/.markdownlint.json'

highlight! link ALEVirtualTextError NonText
highlight! link ALEVirtualTextWarning NonText
highlight! link ALEVirtualTextInfo NonText
highlight! ALEErrorSign ctermfg=203
highlight! ALEWarningSign ctermfg=208
highlight! ALEInfoSign ctermfg=035

nmap <leader>f :ALEFix<CR>
