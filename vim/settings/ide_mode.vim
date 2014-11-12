command -nargs=0 -bar IDEMode call s:startIDEMode()
command -nargs=0 -bar IDEModeClose call s:endIDEMode()
function s:initTlist()
    " Tlistのwindow設定
    let g:Tlist_Use_Right_Window = 1
    let g:Tlist_WinWidth = 32
    " 表示順
    let g:Tlist_Sort_Type = 'order'
    " スペース等を省いたコンパクトな表示
    let g:Tlist_Compact_Format = 0
    " Tlistのwindowだけが残った場合終了する
    let g:Tlist_Exit_OnlyWindow = 1
    " 現在のバッファのタグツリーだけ表示
    let g:Tlist_File_Fold_Auto_Close = 1
    " タグツリーのアウトライン非表示
    let g:Tlist_Enable_Fold_Column = 0
    " 現在のバッファだけ表示
    let g:Tlist_Show_One_File = 1
endfunction
function s:initSrcExpl()
    " window設定
    let g:SrcExpl_winHeight = 7
    " プレビューの表示間隔(ms)
    let g:SrcExpl_refreshTime = 10
    " 競合のプラグイン
    let g:SrcExpl_pluginList = [
        \ '__Tag_List__',
        \ '_NERD_tree_',
        \ 'Source_Explorer'
    \ ]
    " 開くときにtagsファイルの更新を許可しない
    let g:SrcExpl_isUpdateTags = 0
endfunction
function s:initNerdTree()
    " window設定
    let g:NERDTreeWinSize = 32
    let g:NERDTreeWinPos = 'left'
endfunction
function s:startIDEMode()
    call s:initTlist()
    call s:initNerdTree()
    call s:endIDEMode()
    NERDTree
    Tlist
endfunction
function s:endIDEMode()
    silent NERDTreeClose
    silent TlistClose
endfunction

