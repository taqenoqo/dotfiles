Plug 'folti/ShowMarks'

    let g:showmarks_textlower = " "
    let g:showmarks_textupper = " "
    let g:showmarks_textother = " "
    let g:showmarks_include = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

    hi ShowMarksHLl ctermbg=153 ctermfg=69 cterm=BOLD
    hi ShowMarksHLu ctermbg=224 ctermfg=210 cterm=BOLD
    hi ShowMarksHLo ctermbg=231 ctermfg=250
    hi ShowMarksHLm ctermbg=228 ctermfg=208 cterm=BOLD,UNDERLINE

Plug 'taqenoqo/vim-indent-guides', { 'branch': 'right-align' }

    let g:indent_guides_enable_on_vim_startup = 1
    let g:indent_guides_guide_size = 1
    let g:indent_guides_auto_colors = 0
    let g:indent_guides_right_align = 1
    let g:indent_guides_default_mapping = 0

    hi IndentGuidesOdd  ctermbg=195 ctermfg=145
    hi IndentGuidesEven ctermbg=195 ctermfg=145

