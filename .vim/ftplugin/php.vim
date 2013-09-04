set tabstop=4 shiftwidth=4 softtabstop=4
" :makeをしたときに文法チェック
:set makeprg=php\ -l\ %
:set errorformat=%m\ in\ %f\ on\ line\ %l

let php_folding = 1 "フォールディング

" 文字列中のハイライト
let php_htmlInStrings=1
let php_sql_query=1

