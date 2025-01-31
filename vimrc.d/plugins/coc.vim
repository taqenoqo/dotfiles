Plug 'neoclide/coc.nvim', { 'branch': 'release' }

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

    hi link CocErrorSign Error
    hi link CocWarningSign Warning
    hi link CocInfoSign Info
    hi link CocHintSign Info
    hi link CocErrorHighlight CocErrorSign
    hi link CocWarningHighlight CocWarningSign
    hi link CocInfoHighlight CocInfoSign
    hi link CocHintHighlight CocHintSign
    hi link CocMenuSel PmenuSel
    hi link CocFloating Pmenu
    hi link CocFloatThumb PmenuThumb
    hi link CocFloatSbar PmenuSbar

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
        if CocAction('hasProvider', 'hover')
            call CocActionAsync('doHover')
        else
            call feedkeys('K', 'in')
        endif
    endfunction

    augroup coc_hover
        autocmd!
        autocmd CursorHold * call ShowHover()
        autocmd CursorHoldI * call ShowSignature()
    augroup END

    function! ShowHover()
        if get(g:, 'skip_next_coc_float', 0)
            let g:skip_next_coc_float = 0
            return
        endif
        if !get(g:, 'coc_service_initialized', 0) || !CocAction('hasProvider', 'hover') || coc#float#has_float()
            return
        endif
        call CocActionAsync('doHover')
    endfunction

    function! ShowSignature()
        if get(g:, 'skip_next_coc_float', 0)
            let g:skip_next_coc_float = 0
            return
        endif
        if !get(g:, 'coc_service_initialized', 0) || !CocAction('hasProvider', 'signature')
            return
        endif
        call CocActionAsync('showSignatureHelp')
    endfunction

