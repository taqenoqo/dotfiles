Plug 'folti/ShowMarks'

    let g:showmarks_textlower = " "
    let g:showmarks_textupper = " "
    let g:showmarks_textother = " "
    let g:showmarks_include = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

    hi ShowMarksHLl ctermbg=153 ctermfg=69 cterm=BOLD
    hi ShowMarksHLu ctermbg=224 ctermfg=210 cterm=BOLD
    hi ShowMarksHLo ctermbg=231 ctermfg=250
    hi ShowMarksHLm ctermbg=228 ctermfg=208 cterm=BOLD,UNDERLINE

Plug 'Yggdroot/indentLine'

let g:indentLine_defaultGroup = 'IndentLine'
let g:indentLine_char = '▏'
    
Plug 'obcat/vim-sclow'
