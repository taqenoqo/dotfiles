" Vim color file - Takenocolor

set background=light
hi clear
if exists("syntax_on")
    syntax reset
endif
set t_Co=256
let g:colors_name = "Takenocolor"

" 通常のテキスト
hi Normal ctermbg=NONE cterm=NONE

" 関数、メソッド
hi Identifier ctermfg=26 ctermbg=NONE cterm=NONE
     
" キーワード
hi Statement ctermfg=56 ctermbg=NONE cterm=bold
hi link PreProc Statement
hi Type ctermfg=29 ctermbg=NONE cterm=NONE

" 記号
hi Special ctermfg=56 ctermbg=NONE cterm=NONE
hi link Operator Special
hi link Delimiter Special

" 定数
hi link Constant Normal

" リテラル
hi String ctermfg=162 ctermbg=NONE cterm=NONE
hi link Character String
hi link Float String 
hi link Number String
hi link Boolean String

" コメント
hi Comment ctermfg=166 ctermbg=NONE cterm=NONE

" URL等
hi Underlined ctermfg=021 ctermbg=NONE cterm=underline

" TODO
hi Todo ctermfg=160 ctermbg=NONE cterm=bold,underline

" タイトル
hi Title ctermfg=56 ctermbg=NONE cterm=bold

" エラー
hi ErrorSign ctermfg=203 ctermbg=224 cterm=bold
hi WarningSign ctermfg=208 ctermbg=229 cterm=bold
hi InfoSign ctermfg=032 ctermbg=195 cterm=bold
hi Error ctermfg=203 ctermbg=224
hi Warning ctermfg=208 ctermbg=229
hi Info ctermfg=032 ctermbg=195

" 折り畳み
hi Folded ctermfg=239 ctermbg=231 cterm=bold

" 改行やタブなどの記号
hi NonText ctermfg=250 cterm=NONE
hi SpecialKey ctermfg=250 cterm=NONE

" 桁数の限界を示すバー
hi ColorColumn ctermfg=250 ctermbg=195

" 行番号
hi LineNr ctermfg=239 ctermbg=255 cterm=NONE
hi SignColumn ctermfg=239 ctermbg=231 cterm=NONE

" カーソル下の括弧と対応する括弧
hi MatchParen ctermfg=NONE ctermbg=NONE cterm=bold,underline

" 検索ヒット
hi Search ctermfg=NONE ctermbg=229 cterm=NONE
hi IncSearch ctermfg=NONE ctermbg=220 cterm=NONE

" 補完ウインドウ
hi PMenu ctermfg=239 ctermbg=253 cterm=NONE
hi PMenuSbar ctermfg=250 ctermbg=253 cterm=NONE
hi PMenuSel ctermfg=15 ctermbg=68 cterm=NONE
hi PMenuThumb ctermfg=255 ctermbg=250 cterm=NONE

" ステータスラインと境界線
hi StatusLine ctermfg=231 ctermbg=110 cterm=NONE
hi StatusLineNC ctermfg=231 ctermbg=153 cterm=NONE
hi VertSplit ctermfg=153 ctermbg=153 cterm=NONE

" タブバー
hi TabLineFill ctermfg=231 ctermbg=153 cterm=NONE
hi TabLine ctermfg=231 ctermbg=110 cterm=NONE
hi TabLineSel ctermfg=NONE ctermbg=NONE cterm=bold

" diff
hi DiffAdd ctermfg=NONE ctermbg=194 cterm=NONE
hi DiffDelete ctermfg=NONE ctermbg=225 cterm=NONE
hi DiffChange ctermfg=NONE ctermbg=230 cterm=NONE
hi DiffText ctermfg=NONE ctermbg=222 cterm=NONE
hi DiffAddSign ctermfg=114 ctermbg=None cterm=NONE
hi DiffDeleteSign ctermfg=211 ctermbg=None cterm=NONE
hi DiffChangeSign ctermfg=208 ctermbg=None cterm=NONE

" スペルチェック
hi SpellBad ctermfg=NONE ctermbg=225 cterm=NONE
hi SpellCap ctermfg=NONE ctermbg=225 cterm=NONE
hi SpellRare ctermfg=NONE ctermbg=230 cterm=NONE
hi SpellLocal ctermfg=NONE ctermbg=230 cterm=NONE

" conceal の背景色削除
hi clear Conceal

