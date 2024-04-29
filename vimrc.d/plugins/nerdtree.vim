Plug 'scrooloose/nerdtree'

    let g:NERDTreeIgnore = ['^\.DS_Store$[[file]]', '\~$']
    let g:NERDTreeWinSize = 30
    let g:NERDTreeShowHidden = 1
    let g:NERDTreeMinimalUI = 1
    let g:NERDTreeAutoDeleteBuffer = 1

Plug 'rking/ag.vim'

Plug 'taiansu/nerdtree-ag'

Plug 'Xuyuanp/nerdtree-git-plugin'

    let g:NERDTreeGitStatusShowIgnored = 1
    let g:NERDTreeGitStatusIndicatorMapCustom = {
        \ "Untracked" : "!",
        \ "Modified"  : "*",
        \ "Dirty"     : "*",
        \ "Staged"    : "+",
        \ "Renamed"   : ">",
        \ "Unmerged"  : "!",
        \ "Deleted"   : "X",
        \ "Clean"     : "-",
        \ 'Ignored'   : '-',
        \ "Unknown"   : "?"
    \ } 

    hi NERDTreeFlags ctermfg=249
    hi NERDTreeGitStatusUntracked ctermfg=206
    hi NERDTreeGitStatusModified ctermfg=208
    hi NERDTreeGitStatusDirty ctermfg=208
    hi NERDTreeGitStatusStaged ctermfg=077
    hi NERDTreeGitStatusRenamed ctermfg=69
    hi NERDTreeGitStatusUnmerged ctermfg=206
    hi NERDTreeGitStatusStaged ctermfg=077
    hi NERDTreeGitStatusDeleted ctermfg=197
    hi NERDTreeGitStatusClean ctermfg=249
    hi NERDTreeGitStatusIgnored ctermfg=249
    hi NERDTreeGitStatusUnknown ctermfg=249

Plug 'jistr/vim-nerdtree-tabs'

    function! s:nerdtree_auto_start()
        if argc() == 0 && !exists("s:exists_std_in")
            let g:nerdtree_tabs_open_on_console_startup = 1
        endif
    endfunction

    augroup NerdtreeAutoStart
        autocmd!
        autocmd StdinReadPre * let s:exists_std_in = 1
        autocmd VimEnter * call s:nerdtree_auto_start()
    augroup END

