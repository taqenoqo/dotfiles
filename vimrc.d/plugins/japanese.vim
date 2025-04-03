Plug 'vim-jp/vimdoc-ja'

Plug 'rhysd/clever-f.vim'

    let g:clever_f_use_migemo = 1
    let g:clever_f_across_no_line = 1
    let g:clever_f_smart_case = 1
    let g:clever_f_mark_direct = 1

    map ; <Plug>(clever-f-repeat-forward)
    map , <Plug>(clever-f-repeat-back)

Plug 'deton/jasegment.vim'

    let g:jasegment_no_default_key_mappings = 1

    nnoremap b <Plug>JaSegmentMoveNB
    nnoremap w <Plug>JaSegmentMoveNW
    nnoremap e <Plug>JaSegmentMoveNE
    xnoremap b <Plug>JaSegmentMoveVB
    xnoremap w <Plug>JaSegmentMoveVW
    xnoremap e <Plug>JaSegmentMoveVE
    onoremap b <Plug>JaSegmentMoveOB
    onoremap w <Plug>JaSegmentMoveOW
    onoremap e <Plug>JaSegmentMoveOE

