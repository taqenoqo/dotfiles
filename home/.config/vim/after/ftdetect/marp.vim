autocmd BufRead *.md
    \ let s:lines = getline(1, 20) |
    \ let s:in_frontmatter = 0 |
    \ for s:line in s:lines |
    \   if s:line =~# '^---' |
    \     let s:in_frontmatter = !s:in_frontmatter |
    \   elseif s:in_frontmatter && s:line =~# '^\s*marp:\s*true\s*$' |
    \     set filetype=marp | break |
    \   endif |
    \ endfor
