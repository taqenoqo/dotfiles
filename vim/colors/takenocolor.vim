" Vim color file - Takenocolor

set background=light
hi clear
if exists("syntax_on")
    syntax reset
endif
set t_Co=256
let g:colors_name = "Takenocolor"

" 通常のテキスト
hi Normal guifg=#081313 guibg=#E6FDE6 guisp=#081313 gui=NONE ctermbg=NONE cterm=NONE

" 関数、メソッド
hi Identifier guifg=#0033CC guibg=NONE guisp=NONE gui=NONE ctermfg=26 ctermbg=NONE cterm=NONE

" キーワード
hi Statement guifg=#3300CC guibg=NONE guisp=NONE gui=bold ctermfg=56 ctermbg=NONE cterm=bold
hi link PreProc Statement
hi Type guifg=#006633 guibg=NONE guisp=NONE gui=NONE ctermfg=29 ctermbg=NONE cterm=NONE

" 記号
hi Special guifg=#3300CC guibg=NONE guisp=NONE gui=bold ctermfg=56 ctermbg=NONE cterm=NONE
hi link Operator Special
hi link Delimiter Special

" 定数
hi link Constant Normal

" リテラル
hi String guifg=#CC0066 guibg=NONE guisp=NONE gui=NONE ctermfg=162 ctermbg=NONE cterm=NONE
hi link Character String
hi link Float String 
hi link Number String
hi link Boolean String

" コメント
hi Comment guifg=#CC3300 guibg=NONE guisp=NONE gui=NONE ctermfg=166 ctermbg=NONE cterm=NONE

" URL等
hi Underlined guifg=#0000FF guibg=NONE guisp=NONE gui=underline ctermfg=021 ctermbg=NONE cterm=underline

" TODO
hi Todo guifg=#CC0000 guibg=NONE guisp=NONE gui=bold,underline ctermfg=160 ctermbg=NONE cterm=bold,underline

" タイトル
hi Title guifg=#3300CC guibg=NONE guisp=NONE gui=bold ctermfg=56 ctermbg=NONE cterm=bold

" エラー
hi Error guifg=#FF3333 guibg=#FFCCCC guisp=NONE gui=bold ctermfg=203 ctermbg=224 cterm=bold
hi Warning guifg=#FF6600 guibg=#FFFF66 guisp=NONE gui=bold ctermfg=208 ctermbg=228 cterm=bold
hi Info guifg=#009933 guibg=#CCFFCC guisp=NONE gui=bold ctermfg=035 ctermbg=194 cterm=bold

" 折り畳み
hi Folded guifg=#505050 guibg=#FFFFFF gui=NONE ctermfg=239 ctermbg=231 cterm=bold

" 改行やタブなどの記号
hi NonText guifg=#AAAAAA gui=NONE ctermfg=250 cterm=NONE
hi SpecialKey guifg=#AAAAAA gui=NONE ctermfg=250 cterm=NONE

" 行番号
hi LineNr guifg=#505050 guibg=#F0F0F0 guisp=NONE gui=NONE ctermfg=239 ctermbg=255 cterm=NONE
hi SignColumn guifg=#505050 guibg=#F0F0F0 guisp=NONE gui=NONE ctermfg=239 ctermbg=231 cterm=NONE

" カーソル下の括弧と対応する括弧
hi MatchParen ctermfg=NONE ctermbg=NONE cterm=bold,underline

" 検索ヒット
hi Search guifg=#FFFFCC guibg=NONE guisp=NONE gui=bold ctermfg=NONE ctermbg=229 cterm=NONE
hi IncSearch guifg=#FFCC00 guibg=NONE guisp=NONE gui=bold ctermfg=NONE ctermbg=220 cterm=NONE

" 補完ウインドウ
hi PMenu guifg=#505050 guibg=#EAE8E2 guisp=NONE gui=NONE ctermfg=239 ctermbg=253 cterm=NONE
hi PMenuSbar guifg=#B7B7B7 guibg=#EDEDED guisp=NONE gui=NONE ctermfg=250 ctermbg=253 cterm=NONE
hi PMenuSel guifg=#FFFFFF guibg=#3366CC guisp=NONE gui=NONE ctermfg=15 ctermbg=68 cterm=NONE
hi PMenuThumb guifg=#EDEDED guibg=#B7B7B7 guisp=NONE gui=NONE ctermfg=255 ctermbg=250 cterm=NONE

" ステータスラインと境界線
hi StatusLine guifg=#FFFFFF guibg=#006633 gui=NONE ctermfg=231 ctermbg=29 cterm=NONE
hi StatusLineNC guifg=#ffffff guibg=#99CC99 gui=NONE ctermfg=231 ctermbg=151 cterm=NONE
hi VertSplit guifg=#99CC99 guibg=#99CC99 gui=NONE ctermfg=151 ctermbg=151 cterm=NONE

" diff
hi DiffAdd guifg=NONE guibg=#CCFFFF ctermfg=NONE ctermbg=195 cterm=NONE
hi DiffDelete guifg=NONE guibg=#FFCCFF ctermfg=NONE ctermbg=225 cterm=NONE
hi DiffChange guifg=NONE guibg=#FFFFCC ctermfg=NONE ctermbg=230 cterm=NONE
hi DiffText guifg=NONE guibg=#FFCC66 ctermfg=NONE ctermbg=222 cterm=NONE

" スペルチェック
hi SpellBad guifg=NONE guibg=#FFCCFF ctermfg=NONE ctermbg=225 cterm=NONE
hi SpellCap guifg=NONE guibg=#FFCCFF ctermfg=NONE ctermbg=225 cterm=NONE
hi SpellRare guifg=NONE guibg=#FFFFCC ctermfg=NONE ctermbg=230 cterm=NONE
hi SpellLocal guifg=NONE guibg=#FFFFCC ctermfg=NONE ctermbg=230 cterm=NONE

" conceal の背景色削除
hi clear Conceal

