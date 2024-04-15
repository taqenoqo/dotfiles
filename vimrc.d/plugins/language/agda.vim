Plug 'taqenoqo/agda-vim'

let g:agdavim_includeutf8_mapping = v:false
runtime agda-utf8.vim

function CloseSubWindow()
    let l:agdaWinNr = bufwinnr('__Agda__')
    if l:agdaWinNr != -1
        execute l:agdaWinNr . "close"
    endif
endfunction

function SetAgdaKeyMaps()
    nnoremap <buffer> <LocalLeader>l :cclose<CR>:call CloseSubWindow()<CR>:AgdaReload<CR>
    nnoremap <buffer> <LocalLeader>t :cclose<CR>:call CloseSubWindow()<CR>:call AgdaInfer()<CR>
    nnoremap <buffer> <LocalLeader>r :cclose<CR>:call CloseSubWindow()<CR>:call AgdaRefine("False")<CR>
    nnoremap <buffer> <LocalLeader>R :cclose<CR>:call CloseSubWindow()<CR>:call AgdaRefine("True")<CR>
    nnoremap <buffer> <LocalLeader>g :cclose<CR>:call CloseSubWindow()<CR>:call AgdaGive()<CR>
    nnoremap <buffer> <LocalLeader>c :cclose<CR>:call CloseSubWindow()<CR>:call AgdaMakeCase()<CR>
    nnoremap <buffer> <LocalLeader>a :cclose<CR>:call CloseSubWindow()<CR>:call AgdaAuto()<CR>
    nnoremap <buffer> <LocalLeader>e :cclose<CR>:call CloseSubWindow()<CR>:call AgdaContext()<CR>
    nnoremap <buffer> <LocalLeader>n :cclose<CR>:call CloseSubWindow()<CR>:call AgdaNormalize("IgnoreAbstract")<CR>
    nnoremap <buffer> <LocalLeader>N :cclose<CR>:call CloseSubWindow()<CR>:call AgdaNormalize("DefaultCompute")<CR>
    nnoremap <buffer> <LocalLeader>M :cclose<CR>:call CloseSubWindow()<CR>:call AgdaShowModule('')<CR>
    nnoremap <buffer> <LocalLeader>y :cclose<CR>:call CloseSubWindow()<CR>:call AgdaWhyInScope('')<CR>
    nnoremap <buffer> <LocalLeader>h :cclose<CR>:call CloseSubWindow()<CR>:call AgdaHelperFunction()<CR>
    nnoremap <buffer> <LocalLeader>d :cclose<CR>:call CloseSubWindow()<CR>:call AgdaGotoAnnotation()<CR>
    nnoremap <buffer> <LocalLeader>m :cclose<CR>:call CloseSubWindow()<CR>:AgdaMetas<CR>
    nnoremap <buffer> <LocalLeader>sa :AgdaSetRewriteModeAsIs<CR>:cclose<CR>:call CloseSubWindow()<CR>:call AgdaContext()<CR>
    nnoremap <buffer> <LocalLeader>sn :AgdaSetRewriteModeNormal<CR>:cclose<CR>:call CloseSubWindow()<CR>:call AgdaContext()<CR>
    nnoremap <buffer> <LocalLeader>sh :AgdaSetRewriteModeHeadNormal<CR>:cclose<CR>:call CloseSubWindow()<CR>:call AgdaContext()<CR>
endfunction

augroup agda
    autocmd!
    autocmd BufReadPost *.agda call SetAgdaKeyMaps()
augroup END
