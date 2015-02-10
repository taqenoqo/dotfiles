" Vim color file - nuyo

set background=light
hi clear
if exists("syntax_on")
    syntax reset
endif

set t_Co=256
let g:colors_name="nuyo"

" 通常のテキスト
hi Normal guifg=#081313 guibg=#e6fde6 guisp=#081313 gui=NONE ctermbg=NONE cterm=NONE
hi link Constant Normal

" 改行やタブなどの記号
hi NonText guifg=#aaaaaa gui=NONE ctermfg=249 cterm=NONE
hi SpecialKey guifg=#aaaaaa gui=NONE ctermfg=249 cterm=NONE

" 行番号
hi LineNr guifg=#505050 guibg=#eae8e2 guisp=#eae8e2 gui=NONE ctermfg=239 ctermbg=255 cterm=NONE

" コメント
hi Comment guifg=#dd6c26 guibg=NONE guisp=NONE gui=NONE ctermfg=166 ctermbg=NONE cterm=NONE

" リテラル
hi String guifg=#d72926 guibg=NONE guisp=NONE gui=NONE ctermfg=160 ctermbg=NONE cterm=NONE
hi link Character String
hi link Float String 
hi link Number String
hi link Boolean String

" 関数、メソッド
hi Identifier guifg=#2973ea guibg=NONE guisp=NONE gui=NONE ctermfg=26 ctermbg=NONE cterm=NONE

" キーワード
hi Statement guifg=#5c28e9 guibg=NONE guisp=NONE gui=bold ctermfg=56 ctermbg=NONE cterm=bold
hi link PreProc Statement
hi Type guifg=#2973ea guibg=NONE guisp=NONE gui=NONE ctermfg=29 ctermbg=NONE cterm=NONE

" 記号
hi Special guifg=#bb00bb guibg=NONE guisp=NONE gui=italic ctermfg=5 ctermbg=NONE cterm=NONE
hi link Operator Special

" URL等
hi Underlined guifg=#0000ff guibg=NONE guisp=NONE gui=underline ctermfg=4 ctermbg=NONE cterm=underline

" エラー
hi Error guifg=#ff0000 guibg=NONE guisp=NONE gui=bold,underline ctermfg=196 ctermbg=NONE cterm=bold,underline

" TODO
hi Todo guifg=#d72926 guibg=NONE guisp=NONE gui=bold,underline ctermfg=160 ctermbg=NONE cterm=bold,underline

" 補完ウインドウ
hi PMenu guifg=#505050 guibg=#eae8e2 guisp=#eae8e2 gui=NONE ctermfg=239 ctermbg=253 cterm=NONE
hi PMenuSbar guifg=#b7b7b7 guibg=#ededed guisp=#ededed gui=NONE ctermfg=250 ctermbg=253 cterm=NONE
hi PMenuSel guifg=#ffffff guibg=#3966c7 guisp=#3966c7 gui=NONE ctermfg=15 ctermbg=68 cterm=NONE
hi PMenuThumb guifg=#ededed guibg=#b7b7b7 guisp=#b7b7b7 gui=NONE ctermfg=255 ctermbg=250 cterm=NONE

" ステータスラインと境界線
hi StatusLine guifg=#ffffff guibg=#0ea279 gui=NONE ctermfg=231 ctermbg=29 cterm=NONE
hi StatusLineNC guifg=#ffffff guibg=#b7e3bf gui=NONE ctermfg=231 ctermbg=151 cterm=NONE
hi VertSplit guifg=#b7e3bf guibg=#b7e3bf gui=NONE ctermfg=151 ctermbg=151 cterm=NONE

" 折り畳み
hi Folded guifg=#005faf guibg=#ffffff gui=NONE ctermfg=25 ctermbg=231 cterm=NONE
hi FoldColumn guifg=#005faf guibg=#ffffff gui=NONE ctermfg=25 ctermbg=231 cterm=NONE

" diff
hi DiffAdd guifg=NONE guibg=#d5ffff ctermfg=NONE ctermbg=195 cterm=NONE
hi DiffDelete guifg=NONE guibg=#ffdcff ctermfg=NONE ctermbg=225 cterm=NONE
hi DiffChange guifg=NONE guibg=#feffdc ctermfg=NONE ctermbg=230 cterm=NONE
hi DiffText guifg=NONE guibg=#ffdf90 ctermfg=NONE ctermbg=222 cterm=NONE
