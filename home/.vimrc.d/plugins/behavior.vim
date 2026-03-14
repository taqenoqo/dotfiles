Plug 'vim-scripts/sudo.vim'

Plug 'vim-scripts/surround.vim'

    let g:surround_no_mappings = 1
    let g:surround_106 = "「\r」"

    nmap ds <Plug>Dsurround
    nmap cs <Plug>Csurround
    nmap s <Plug>Ysurround
    xmap s <Plug>VSurround

Plug 'vim-scripts/camelcasemotion'

    function CamelcasemotionCb()
        unmap ,e
        unmap ,b
        unmap ,w
    endfunction
    autocmd VimEnter * call CamelcasemotionCb()

    omap <silent> ic <Plug>CamelCaseMotion_ie
    vmap <silent> ic <Plug>CamelCaseMotion_ie
    omap <silent> ac <Plug>CamelCaseMotion_iw
    vmap <silent> ac <Plug>CamelCaseMotion_iw

Plug 'vim-scripts/open-browser.vim'

    nmap <Leader>b <Plug>(openbrowser-smart-search)
    vmap <Leader>b <Plug>(openbrowser-smart-search)

Plug 'yuttie/comfortable-motion.vim'

    let g:comfortable_motion_interval = 1000.0/60
    let g:comfortable_motion_scroll_down_key = "j"
    let g:comfortable_motion_scroll_up_key = "k"
    nnoremap <silent> <C-d> :call comfortable_motion#flick(100)<CR>
    nnoremap <silent> <C-u> :call comfortable_motion#flick(-100)<CR>
    let g:comfortable_motion_friction = 20.0
    let g:comfortable_motion_air_drag = 4.0

Plug 'junegunn/vim-easy-align'

    let g:easy_align_delimiters = 
    \ {
        \ '/': {
            \ 'pattern':         '//\+\|/\*\|\*/',
            \ 'delimiter_align': 'l',
            \ 'ignore_groups':   ['!Comment'] 
        \ }
    \ }

    xmap <Leader>a <Plug>(LiveEasyAlign)
    nmap <Leader>a <Plug>(LiveEasyAlign)

Plug 'gyim/vim-boxdraw'

    nnoremap <Leader>d :call BoxdrawToggle('virtualedit', 'all')<CR>
    function! BoxdrawToggle(option, flag)
        exec ('let lopt = &' . a:option)
        if lopt =~ (".*" . a:flag . ".*")
            exec ('set ' . a:option . '-=' . a:flag)
        else
            exec ('set ' . a:option . '+=' . a:flag)
        endif
    endfunction
    vnoremap ab :<C-u>call boxdraw#Select("ao")<CR>
    vnoremap ib :<C-u>call boxdraw#Select("io")<CR>

Plug 'editorconfig/editorconfig-vim'
  
    let g:EditorConfig_exclude_patterns = ['fugitive://.*']

Plug 'voldikss/vim-translator'

    let g:translator_default_engines = ['google']
    let g:translator_target_lang = 'ja'
    vmap <Leader>te :TranslateR --target_lang=en<CR>
    vmap <Leader>tj :TranslateR --target_lang=ja<CR>
