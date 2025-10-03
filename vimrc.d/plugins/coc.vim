Plug 'neoclide/coc.nvim', { 'branch': 'release'}
    let g:coc_config_home = "~/.vim/coc/"
    let g:coc_data_home = "~/.vimcache/coc/"
    let g:coc_global_extensions = [
        \ 'coc-json', 
        \ 'coc-git',
        \ 'coc-vimlsp',
        \ 'coc-emoji',
        \ 'coc-yaml',
        \ 'coc-diagnostic',
        \ 'coc-lists',
        \ 'coc-spell-checker',
        \ 'coc-java',
        \ 'coc-tsserver',
        \ 'coc-solargraph',
        \ '@yaegassy/coc-marksman'
    \ ]

    hi link CocErrorSign ErrorSign
    hi link CocWarningSign WarningSign
    hi link CocInfoSign InfoSign
    hi link CocHintSign InfoSign

    hi link CocErrorHighlight Error
    hi link CocWarningHighlight Warning
    hi link CocInfoHighlight Info
    hi CocErrorFloat ctermfg=203 ctermbg=253 cterm=none
    hi CocWarningFloat ctermfg=208 ctermbg=253 cterm=none
    hi CocInfoFloat ctermfg=032 ctermbg=253 cterm=none
    hi link CocHintHighlight Info
    hi link CocMenuSel PmenuSel
    hi link CocFloating Pmenu
    hi link CocFloatThumb PmenuThumb
    hi link CocFloatSbar PmenuSbar
    hi CocInlayHint ctermfg=188 ctermbg=NONE cterm=NONE

    xmap <leader>= <Plug>(coc-format-selected)
    nmap <leader>= <Plug>(coc-format-selected)
    nmap <leader>n <Plug>(coc-rename)
    xmap <leader>A <Plug>(coc-codeaction-selected)
    nmap <leader>A <Plug>(coc-codeaction-cursor)
    xmap <leader>M <Plug>(coc-codeaction-selected)
    nmap <leader>M <Plug>(coc-codeaction-cursor)
    nmap <silent> [g <Plug>(coc-diagnostic-prev)
    nmap <silent> ]g <Plug>(coc-diagnostic-next)
    nmap <silent> gd <Plug>(coc-definition)
    nmap <silent> gt <Plug>(coc-type-definition)
    nmap <silent> gI <Plug>(coc-implementation)
    nmap <silent> gr <Plug>(coc-references)
    xmap if <Plug>(coc-funcobj-i)
    omap if <Plug>(coc-funcobj-i)
    xmap af <Plug>(coc-funcobj-a)
    omap af <Plug>(coc-funcobj-a)
    xmap iC <Plug>(coc-classobj-i)
    omap iC <Plug>(coc-classobj-i)
    xmap aC <Plug>(coc-classobj-a)
    omap aC <Plug>(coc-classobj-a)
    nnoremap <silent> <C-L> :noh \| :pclose \| :let g:skip_next_coc_float = 1 \| :call coc#float#close_all()<CR><C-L>
    inoremap <silent> <C-L> <C-\><C-o>:noh \| :pclose \| :let g:skip_next_coc_float = 1 \| :call coc#float#close_all()<CR><C-\><C-o><C-L>

    inoremap <silent><expr> <C-n> 
        \ coc#pum#visible() ? coc#pum#next(1) :
        \ coc#refresh()
    inoremap <silent><expr> <C-p> 
        \ coc#pum#visible() ? coc#pum#prev(1) :
        \ coc#refresh()
    inoremap <silent><expr> <TAB>
        \ coc#pum#visible() ? coc#pum#next(1) :
        \ CheckBackspace() ? "\<Tab>" :
        \ coc#refresh()
    function! CheckBackspace() abort
        let col = col('.') - 1
        return !col || getline('.')[col - 1]  =~# '\s'
    endfunction
    inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

    if has('nvim-0.4.0') || has('patch-8.2.0750')
        nnoremap <silent><nowait><expr> <C-j> coc#float#has_scroll() ? coc#float#scroll(1, 1) : "\<C-j>"
        nnoremap <silent><nowait><expr> <C-k> coc#float#has_scroll() ? coc#float#scroll(0, 1) : "\<C-k>"
        inoremap <silent><nowait><expr> <C-j> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1, 1)\<cr>" : "\<C-j>"
        inoremap <silent><nowait><expr> <C-k> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0, 1)\<cr>" : "\<C-k>"
        vnoremap <silent><nowait><expr> <C-j> coc#float#has_scroll() ? coc#float#scroll(1, 1) : "\<C-j>"
        vnoremap <silent><nowait><expr> <C-k> coc#float#has_scroll() ? coc#float#scroll(0, 1) : "\<C-k>"
    endif

    nnoremap <silent> K :call ShowDocumentation()<CR>
    function! ShowDocumentation()
        if CocHasProvider('hover')
            call CocActionAsync('doHover')
        else
            call feedkeys('K', 'in')
        endif
    endfunction

    augroup coc_hover
        autocmd!
        autocmd CursorHold * call s:ShowHover()
        autocmd CursorHoldI * call s:ShowSignature()
    augroup END

    function! s:ShowHover()
        if get(g:, 'skip_next_hover', 0)
            let g:skip_next_hover = 0
            return
        endif
        if !get(g:, 'coc_service_initialized', 0) || !CocHasProvider('hover') || coc#float#has_float()
            return
        endif
        call CocActionAsync('doHover')
    endfunction

    function! s:ShowSignature()
        if get(g:, 'skip_next_hover', 0)
            let g:skip_next_hover = 0
            return
        endif
        if !get(g:, 'coc_service_initialized', 0) || !CocHasProvider('signature')
            return
        endif
        call CocActionAsync('showSignatureHelp')
    endfunction

