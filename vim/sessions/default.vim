let SessionLoad = 1
if &cp | set nocp | endif
let s:cpo_save=&cpo
set cpo&vim
inoremap <silent> <expr> <BS> coc#_insert_key('request', 'iPGJzPg==0')
inoremap <silent> <Plug>CocRefresh =coc#_complete()
inoremap <nowait> <silent> <expr> <C-K> coc#float#has_scroll() ? "\=coc#float#scroll(0, 1)\" : "\"
inoremap <nowait> <silent> <expr> <C-J> coc#float#has_scroll() ? "\=coc#float#scroll(1, 1)\" : "\<NL>"
inoremap <silent> <expr> <C-@> coc#refresh()
inoremap <expr> <S-Tab> pumvisible() ? "\" : "\"
inoremap <C-U> :call unicoder#start(1)
inoremap <silent> <expr> <Nul> coc#refresh()
map! <D-v> *
nnoremap <silent>  :call comfortable_motion#flick(-200)
nnoremap <silent>  :call comfortable_motion#flick(100)
nnoremap <silent>  :call comfortable_motion#flick(200)
vnoremap <nowait> <silent> <expr> <NL> coc#float#has_scroll() ? coc#float#scroll(1, 1) : "\<NL>"
nnoremap <nowait> <silent> <expr> <NL> coc#float#has_scroll() ? coc#float#scroll(1, 1) : "\<NL>"
vnoremap <nowait> <silent> <expr>  coc#float#has_scroll() ? coc#float#scroll(0, 1) : "\"
nnoremap <nowait> <silent> <expr>  coc#float#has_scroll() ? coc#float#scroll(0, 1) : "\"
nnoremap <silent>  :noh | :pclose
nnoremap  :tabnext
nnoremap  :tabprevious
nnoremap <silent>  :call comfortable_motion#flick(-100)
map <silent>  mm :ShowMarksPlaceMark
map <silent>  ma :ShowMarksClearAll
map <silent>  mh :ShowMarksClearMark
map <silent>  mo :ShowMarksOn
map <silent>  mt :ShowMarksToggle
xnoremap <silent>  r :call dein#autoload#_on_map('<Leader>r', 'vim-quickrun','x')
nnoremap <silent>  r :call dein#autoload#_on_map('<Leader>r', 'vim-quickrun','n')
nmap <silent>  R <Plug>(coc-references)
nmap <silent>  i <Plug>(coc-implementation)
nmap <silent>  t <Plug>(coc-type-definition)
nmap  M <Plug>(coc-codeaction-cursor)
xmap  M <Plug>(coc-codeaction-selected)
nmap  A <Plug>(coc-codeaction-cursor)
xmap  A <Plug>(coc-codeaction-selected)
nmap  n <Plug>(coc-rename)
nmap  f <Plug>(coc-format-selected)
xmap  f <Plug>(coc-format-selected)
nnoremap  Gg :GtagsCreate
nnoremap  Gp :cp
nnoremap  Gn :cn
nnoremap  Gi :Gtags
nnoremap  Gl :Gtags -f %
nnoremap  Gr :Gtags -r 
nnoremap  G :Gtags 
nmap  gb :Gblame
nmap  ga :Gwrite
nmap  gl :Glog | copen
nmap  gd :Gdiff
nmap  gs :Gstatus
nmap  gc :Gcommit
nmap <silent>  d <Plug>(coc-definition)
vmap  b <Plug>(openbrowser-smart-search)
nmap  b <Plug>(openbrowser-smart-search)
nmap  a <Plug>(LiveEasyAlign)
xmap  a <Plug>(LiveEasyAlign)
vnoremap +| :call boxdraw#Draw("+|", [])
vnoremap +_ :call boxdraw#Draw("+_", [])
vnoremap +- :call boxdraw#Draw("+-", [])
vnoremap ++^ :call boxdraw#Draw("++^", [])
vnoremap ++V :call boxdraw#Draw("++v", [])
vnoremap ++v :call boxdraw#Draw("++v", [])
vnoremap ++< :call boxdraw#Draw("++<", [])
vnoremap ++> :call boxdraw#Draw("++>", [])
vnoremap +^ :call boxdraw#Draw("+^", [])
vnoremap +V :call boxdraw#Draw("+v", [])
vnoremap +v :call boxdraw#Draw("+v", [])
vnoremap +< :call boxdraw#Draw("+<", [])
vnoremap +> :call boxdraw#Draw("+>", [])
vnoremap +D :echo boxdraw#debug()
vnoremap +]c :call boxdraw#DrawWithLabel("+]c", [])
vnoremap +[c :call boxdraw#DrawWithLabel("+[c", [])
vnoremap +}]c :call boxdraw#DrawWithLabel("+}]c", [])
vnoremap +}[c :call boxdraw#DrawWithLabel("+}[c", [])
vnoremap +{]c :call boxdraw#DrawWithLabel("+{]c", [])
vnoremap +{[c :call boxdraw#DrawWithLabel("+{[c", [])
vnoremap +}c :call boxdraw#DrawWithLabel("+}c", [])
vnoremap +{c :call boxdraw#DrawWithLabel("+{c", [])
vnoremap +c :call boxdraw#DrawWithLabel("+c", [])
vnoremap +}]O :call boxdraw#DrawWithLabel("+}]O", [])
vnoremap +}[O :call boxdraw#DrawWithLabel("+}[O", [])
vnoremap +{]O :call boxdraw#DrawWithLabel("+{]O", [])
vnoremap +{[O :call boxdraw#DrawWithLabel("+{[O", [])
vnoremap +]O :call boxdraw#DrawWithLabel("+]O", [])
vnoremap +[O :call boxdraw#DrawWithLabel("+[O", [])
vnoremap +O :call boxdraw#DrawWithLabel("+O", [])
vnoremap +o :call boxdraw#Draw("+o", [])
xmap ,e <Plug>CamelCaseMotion_e
xmap ,b <Plug>CamelCaseMotion_b
xmap ,w <Plug>CamelCaseMotion_w
omap ,e <Plug>CamelCaseMotion_e
omap ,b <Plug>CamelCaseMotion_b
omap ,w <Plug>CamelCaseMotion_w
nmap ,e <Plug>CamelCaseMotion_e
nmap ,b <Plug>CamelCaseMotion_b
nmap ,w <Plug>CamelCaseMotion_w
nnoremap <silent> K :call ShowDocumentation()
nmap [h <Plug>GitGutterPrevHunk
nmap ]h <Plug>GitGutterNextHunk
vnoremap ao :call boxdraw#Select("ao")
vmap <silent> ac <Plug>CamelCaseMotion_iw
omap <silent> ac <Plug>CamelCaseMotion_iw
vnoremap ab :call boxdraw#Select("ao")
nmap cs <Plug>Csurround
nmap ds <Plug>Dsurround
nnoremap <silent> dm :delmarks! | delm A-Z0-9
xmap gx <Plug>NetrwBrowseXVis
nmap gx <Plug>NetrwBrowseX
xmap i,b <Plug>CamelCaseMotion_ib
omap i,b <Plug>CamelCaseMotion_ib
vnoremap io :call boxdraw#Select("io")
vmap <silent> ic <Plug>CamelCaseMotion_ie
omap <silent> ic <Plug>CamelCaseMotion_ie
vnoremap ib :call boxdraw#Select("io")
xmap s <Plug>VSurround
nmap s <Plug>Ysurround
xnoremap <silent> <Plug>(coc-git-chunk-outer) :call coc#rpc#request('doKeymap', ['git-chunk-outer'])
onoremap <silent> <Plug>(coc-git-chunk-outer) :call coc#rpc#request('doKeymap', ['git-chunk-outer'])
xnoremap <silent> <Plug>(coc-git-chunk-inner) :call coc#rpc#request('doKeymap', ['git-chunk-inner'])
onoremap <silent> <Plug>(coc-git-chunk-inner) :call coc#rpc#request('doKeymap', ['git-chunk-inner'])
nnoremap <silent> <Plug>(coc-git-commit) :call coc#rpc#notify('doKeymap', ['git-commit'])
nnoremap <silent> <Plug>(coc-git-chunkinfo) :call coc#rpc#notify('doKeymap', ['git-chunkinfo'])
nnoremap <silent> <Plug>(coc-git-keepboth) :call coc#rpc#notify('doKeymap', ['git-keepboth'])
nnoremap <silent> <Plug>(coc-git-keepincoming) :call coc#rpc#notify('doKeymap', ['git-keepincoming'])
nnoremap <silent> <Plug>(coc-git-keepcurrent) :call coc#rpc#notify('doKeymap', ['git-keepcurrent'])
nnoremap <silent> <Plug>(coc-git-prevconflict) :call coc#rpc#notify('doKeymap', ['git-prevconflict'])
nnoremap <silent> <Plug>(coc-git-nextconflict) :call coc#rpc#notify('doKeymap', ['git-nextconflict'])
nnoremap <silent> <Plug>(coc-git-prevchunk) :call coc#rpc#notify('doKeymap', ['git-prevchunk'])
nnoremap <silent> <Plug>(coc-git-nextchunk) :call coc#rpc#notify('doKeymap', ['git-nextchunk'])
xnoremap <silent> <Plug>NetrwBrowseXVis :call netrw#BrowseXVis()
nnoremap <silent> <Plug>NetrwBrowseX :call netrw#BrowseX(netrw#GX(),netrw#CheckIfRemote(netrw#GX()))
nnoremap <silent> <Plug>SurroundRepeat .
vnoremap <silent> <Plug>(openbrowser-smart-search) :call openbrowser#_keymapping_smart_search('v')
nnoremap <silent> <Plug>(openbrowser-smart-search) :call openbrowser#_keymapping_smart_search('n')
vnoremap <silent> <Plug>(openbrowser-search) :call openbrowser#_keymapping_search('v')
nnoremap <silent> <Plug>(openbrowser-search) :call openbrowser#_keymapping_search('n')
vnoremap <silent> <Plug>(openbrowser-open) :call openbrowser#_keymapping_open('v')
nnoremap <silent> <Plug>(openbrowser-open) :call openbrowser#_keymapping_open('n')
nnoremap <silent> <Plug>GitGutterPreviewHunk :call gitgutter#utility#warn('Please change your map <Plug>GitGutterPreviewHunk to <Plug>(GitGutterPreviewHunk)')
nnoremap <silent> <Plug>(GitGutterPreviewHunk) :GitGutterPreviewHunk
nnoremap <silent> <Plug>GitGutterUndoHunk :call gitgutter#utility#warn('Please change your map <Plug>GitGutterUndoHunk to <Plug>(GitGutterUndoHunk)')
nnoremap <silent> <Plug>(GitGutterUndoHunk) :GitGutterUndoHunk
nnoremap <silent> <Plug>GitGutterStageHunk :call gitgutter#utility#warn('Please change your map <Plug>GitGutterStageHunk to <Plug>(GitGutterStageHunk)')
nnoremap <silent> <Plug>(GitGutterStageHunk) :GitGutterStageHunk
xnoremap <silent> <Plug>GitGutterStageHunk :call gitgutter#utility#warn('Please change your map <Plug>GitGutterStageHunk to <Plug>(GitGutterStageHunk)')
xnoremap <silent> <Plug>(GitGutterStageHunk) :GitGutterStageHunk
nnoremap <silent> <expr> <Plug>GitGutterPrevHunk &diff ? '[c' : ":\call gitgutter#utility#warn('Please change your map \<Plug>GitGutterPrevHunk to \<Plug>(GitGutterPrevHunk)')\"
nnoremap <silent> <expr> <Plug>(GitGutterPrevHunk) &diff ? '[c' : ":\execute v:count1 . 'GitGutterPrevHunk'\"
nnoremap <silent> <expr> <Plug>GitGutterNextHunk &diff ? ']c' : ":\call gitgutter#utility#warn('Please change your map \<Plug>GitGutterNextHunk to \<Plug>(GitGutterNextHunk)')\"
nnoremap <silent> <expr> <Plug>(GitGutterNextHunk) &diff ? ']c' : ":\execute v:count1 . 'GitGutterNextHunk'\"
xnoremap <silent> <Plug>(GitGutterTextObjectOuterVisual) :call gitgutter#hunk#text_object(0)
xnoremap <silent> <Plug>(GitGutterTextObjectInnerVisual) :call gitgutter#hunk#text_object(1)
onoremap <silent> <Plug>(GitGutterTextObjectOuterPending) :call gitgutter#hunk#text_object(0)
onoremap <silent> <Plug>(GitGutterTextObjectInnerPending) :call gitgutter#hunk#text_object(1)
nnoremap <silent> <C-B> :call comfortable_motion#flick(-200)
nnoremap <silent> <C-F> :call comfortable_motion#flick(200)
onoremap <silent> <Plug>(coc-classobj-a) :call CocAction('selectSymbolRange', v:false, '', ['Interface', 'Struct', 'Class'])
onoremap <silent> <Plug>(coc-classobj-i) :call CocAction('selectSymbolRange', v:true, '', ['Interface', 'Struct', 'Class'])
vnoremap <silent> <Plug>(coc-classobj-a) :call CocAction('selectSymbolRange', v:false, visualmode(), ['Interface', 'Struct', 'Class'])
vnoremap <silent> <Plug>(coc-classobj-i) :call CocAction('selectSymbolRange', v:true, visualmode(), ['Interface', 'Struct', 'Class'])
onoremap <silent> <Plug>(coc-funcobj-a) :call CocAction('selectSymbolRange', v:false, '', ['Method', 'Function'])
onoremap <silent> <Plug>(coc-funcobj-i) :call CocAction('selectSymbolRange', v:true, '', ['Method', 'Function'])
vnoremap <silent> <Plug>(coc-funcobj-a) :call CocAction('selectSymbolRange', v:false, visualmode(), ['Method', 'Function'])
vnoremap <silent> <Plug>(coc-funcobj-i) :call CocAction('selectSymbolRange', v:true, visualmode(), ['Method', 'Function'])
nnoremap <silent> <Plug>(coc-cursors-position) :call CocAction('cursorsSelect', bufnr('%'), 'position', 'n')
nnoremap <silent> <Plug>(coc-cursors-word) :call CocAction('cursorsSelect', bufnr('%'), 'word', 'n')
vnoremap <silent> <Plug>(coc-cursors-range) :call CocAction('cursorsSelect', bufnr('%'), 'range', visualmode())
nnoremap <silent> <Plug>(coc-refactor) :call       CocActionAsync('refactor')
nnoremap <silent> <Plug>(coc-command-repeat) :call       CocAction('repeatCommand')
nnoremap <silent> <Plug>(coc-float-jump) :call       coc#float#jump()
nnoremap <silent> <Plug>(coc-float-hide) :call       coc#float#close_all()
nnoremap <silent> <Plug>(coc-fix-current) :call       CocActionAsync('doQuickfix')
nnoremap <silent> <Plug>(coc-openlink) :call       CocActionAsync('openLink')
nnoremap <silent> <Plug>(coc-references-used) :call       CocActionAsync('jumpUsed')
nnoremap <silent> <Plug>(coc-references) :call       CocActionAsync('jumpReferences')
nnoremap <silent> <Plug>(coc-type-definition) :call       CocActionAsync('jumpTypeDefinition')
nnoremap <silent> <Plug>(coc-implementation) :call       CocActionAsync('jumpImplementation')
nnoremap <silent> <Plug>(coc-declaration) :call       CocActionAsync('jumpDeclaration')
nnoremap <silent> <Plug>(coc-definition) :call       CocActionAsync('jumpDefinition')
nnoremap <silent> <Plug>(coc-diagnostic-prev-error) :call       CocActionAsync('diagnosticPrevious', 'error')
nnoremap <silent> <Plug>(coc-diagnostic-next-error) :call       CocActionAsync('diagnosticNext',     'error')
nnoremap <silent> <Plug>(coc-diagnostic-prev) :call       CocActionAsync('diagnosticPrevious')
nnoremap <silent> <Plug>(coc-diagnostic-next) :call       CocActionAsync('diagnosticNext')
nnoremap <silent> <Plug>(coc-diagnostic-info) :call       CocActionAsync('diagnosticInfo')
nnoremap <silent> <Plug>(coc-format) :call       CocActionAsync('format')
nnoremap <silent> <Plug>(coc-rename) :call       CocActionAsync('rename')
nnoremap <Plug>(coc-codeaction-cursor) :call       CocActionAsync('codeAction',         'cursor')
nnoremap <Plug>(coc-codeaction-line) :call       CocActionAsync('codeAction',         'line')
nnoremap <Plug>(coc-codeaction) :call       CocActionAsync('codeAction',         '')
vnoremap <silent> <Plug>(coc-codeaction-selected) :call       CocActionAsync('codeAction',         visualmode())
vnoremap <silent> <Plug>(coc-format-selected) :call       CocActionAsync('formatSelected',     visualmode())
nnoremap <Plug>(coc-codelens-action) :call       CocActionAsync('codeLensAction')
nnoremap <Plug>(coc-range-select) :call       CocActionAsync('rangeSelect',     '', v:true)
vnoremap <silent> <Plug>(coc-range-select-backward) :call       CocActionAsync('rangeSelect',     visualmode(), v:false)
vnoremap <silent> <Plug>(coc-range-select) :call       CocActionAsync('rangeSelect',     visualmode(), v:true)
vnoremap <silent> <Plug>CamelCaseMotion_ie :call camelcasemotion#InnerMotion('e',v:count1)
vnoremap <silent> <Plug>CamelCaseMotion_ib :call camelcasemotion#InnerMotion('b',v:count1)
vnoremap <silent> <Plug>CamelCaseMotion_iw :call camelcasemotion#InnerMotion('w',v:count1)
onoremap <silent> <Plug>CamelCaseMotion_ie :call camelcasemotion#InnerMotion('e',v:count1)
onoremap <silent> <Plug>CamelCaseMotion_ib :call camelcasemotion#InnerMotion('b',v:count1)
onoremap <silent> <Plug>CamelCaseMotion_iw :call camelcasemotion#InnerMotion('w',v:count1)
vnoremap <silent> <Plug>CamelCaseMotion_e :call camelcasemotion#Motion('e',v:count1,'v')
vnoremap <silent> <Plug>CamelCaseMotion_b :call camelcasemotion#Motion('b',v:count1,'v')
vnoremap <silent> <Plug>CamelCaseMotion_w :call camelcasemotion#Motion('w',v:count1,'v')
onoremap <silent> <Plug>CamelCaseMotion_e :call camelcasemotion#Motion('e',v:count1,'o')
onoremap <silent> <Plug>CamelCaseMotion_b :call camelcasemotion#Motion('b',v:count1,'o')
onoremap <silent> <Plug>CamelCaseMotion_w :call camelcasemotion#Motion('w',v:count1,'o')
nnoremap <silent> <Plug>CamelCaseMotion_e :call camelcasemotion#Motion('e',v:count1,'n')
nnoremap <silent> <Plug>CamelCaseMotion_b :call camelcasemotion#Motion('b',v:count1,'n')
nnoremap <silent> <Plug>CamelCaseMotion_w :call camelcasemotion#Motion('w',v:count1,'n')
vnoremap <nowait> <silent> <expr> <C-K> coc#float#has_scroll() ? coc#float#scroll(0, 1) : "\"
vnoremap <nowait> <silent> <expr> <C-J> coc#float#has_scroll() ? coc#float#scroll(1, 1) : "\<NL>"
nnoremap <nowait> <silent> <expr> <C-K> coc#float#has_scroll() ? coc#float#scroll(0, 1) : "\"
nnoremap <nowait> <silent> <expr> <C-J> coc#float#has_scroll() ? coc#float#scroll(1, 1) : "\<NL>"
nnoremap <silent> <C-U> :call comfortable_motion#flick(-100)
nnoremap <silent> <C-D> :call comfortable_motion#flick(100)
nnoremap <C-N> :tabnext
nnoremap <C-P> :tabprevious
nnoremap <silent> <C-L> :noh | :pclose
vmap <BS> "-d
vmap <D-x> "*d
vmap <D-c> "*y
vmap <D-v> "-d"*P
nmap <D-v> "*P
inoremap <nowait> <silent> <expr> <NL> coc#float#has_scroll() ? "\=coc#float#scroll(1, 1)\" : "\<NL>"
inoremap <nowait> <silent> <expr>  coc#float#has_scroll() ? "\=coc#float#scroll(0, 1)\" : "\"
inoremap  :call unicoder#start(1)
inoremap <silent> <expr> " coc#_insert_key('request', 'iIg==0')
inoremap <silent> <expr> ' coc#_insert_key('request', 'iJw==0')
inoremap <silent> <expr> ( coc#_insert_key('request', 'iKA==0')
inoremap <silent> <expr> ) coc#_insert_key('request', 'iKQ==0')
inoremap <silent> <expr> < coc#_insert_key('request', 'iPA==0')
inoremap <silent> <expr> > coc#_insert_key('request', 'iPg==0')
inoremap <silent> <expr> [ coc#_insert_key('request', 'iWw==0')
inoremap <silent> <expr> ] coc#_insert_key('request', 'iXQ==0')
inoremap <silent> <expr> ` coc#_insert_key('request', 'iYA==0')
inoremap <silent> <expr> { coc#_insert_key('request', 'iew==0')
inoremap <silent> <expr> } coc#_insert_key('request', 'ifQ==0')
let &cpo=s:cpo_save
unlet s:cpo_save
set autoindent
set backspace=indent,eol,start
set backup
set backupdir=~/.vimcache/backup
set backupskip=/tmp/*,/private/tmp/*
set completeopt=menuone,noinsert,noselect
set directory=~/.vimcache/swap
set expandtab
set fileencodings=ucs-bom,utf-8,iso-2022-jp,euc-jp,cp932
set fillchars=
set helplang=ja
set hlsearch
set ignorecase
set incsearch
set nojoinspaces
set laststatus=2
set listchars=tab:»-,trail:-,eol:↓,extends:»,precedes:«,nbsp:%
set mouse=a
set nrformats=bin,hex,alpha
set runtimepath=~/.vim,/usr/local/share/vim/vimfiles,~/.dein/repos/github.com/Shougo/vimproc.vim,~/.dein/.cache/.vimrc/.dein,/usr/local/share/vim/vim82,~/.dein/.cache/.vimrc/.dein/after,/usr/local/share/vim/vimfiles/after,~/.vim/after,~/.vim/dein.vim
set scrolloff=5
set shiftwidth=4
set shortmess=filnxtToOSc
set showcmd
set smartindent
set spelllang=en,cjk
set nostartofline
set tabstop=4
set textwidth=120
set notimeout
set ttimeout
set ttimeoutlen=0
set undodir=~/.vimcache/undo
set undofile
set updatetime=100
set viminfo='100,<50,s10,h,n/Users/takenoko/.vimcache/viminfo
set wildmenu
let s:so_save = &g:so | let s:siso_save = &g:siso | setg so=0 siso=0 | setl so=-1 siso=-1
let v:this_session=expand("<sfile>:p")
silent only
silent tabonly
cd ~/Playground
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
set shortmess=aoO
badd +0 hoge.rb
argglobal
%argdel
$argadd hoge.rb
edit hoge.rb
argglobal
let s:cpo_save=&cpo
set cpo&vim
cmap <buffer> <C-R><C-F> <Plug><cfile>
nmap <buffer>  hp <Plug>(GitGutterPreviewHunk)
nmap <buffer>  hu <Plug>(GitGutterUndoHunk)
nmap <buffer>  hs <Plug>(GitGutterStageHunk)
xmap <buffer>  hs <Plug>(GitGutterStageHunk)
nmap <buffer> [c <Plug>(GitGutterPrevHunk)
nmap <buffer> ]c <Plug>(GitGutterNextHunk)
cmap <buffer>  <Plug><cfile>
let &cpo=s:cpo_save
unlet s:cpo_save
setlocal keymap=
setlocal noarabic
setlocal autoindent
setlocal backupcopy=
setlocal balloonexpr=
setlocal nobinary
setlocal nobreakindent
setlocal breakindentopt=
setlocal bufhidden=
setlocal buflisted
setlocal buftype=
setlocal nocindent
setlocal cinkeys=0{,0},0),0],:,0#,!^F,o,O,e
setlocal cinoptions=
setlocal cinwords=if,else,while,do,for,switch
setlocal colorcolumn=
setlocal comments=:#
setlocal commentstring=#\ %s
setlocal complete=.,w,b,u,t,i
setlocal concealcursor=
set conceallevel=2
setlocal conceallevel=2
setlocal completefunc=
setlocal nocopyindent
setlocal cryptmethod=
setlocal nocursorbind
setlocal nocursorcolumn
setlocal nocursorline
setlocal cursorlineopt=both
setlocal define=
setlocal dictionary=
setlocal nodiff
setlocal equalprg=
setlocal errorformat=
setlocal expandtab
if &filetype != 'ruby'
setlocal filetype=ruby
endif
setlocal fixendofline
setlocal foldcolumn=0
setlocal foldenable
setlocal foldexpr=0
setlocal foldignore=#
set foldlevel=2
setlocal foldlevel=2
setlocal foldmarker={{{,}}}
set foldmethod=syntax
setlocal foldmethod=syntax
setlocal foldminlines=1
set foldnestmax=2
setlocal foldnestmax=2
set foldtext=MyFoldText()
setlocal foldtext=MyFoldText()
setlocal formatexpr=
setlocal formatoptions=croql
setlocal formatlistpat=^\\s*\\d\\+[\\]:.)}\\t\ ]\\s*
setlocal formatprg=
setlocal grepprg=
setlocal iminsert=0
setlocal imsearch=-1
setlocal include=^\\s*\\<\\(load\\>\\|require\\>\\|autoload\\s*:\\=[\"']\\=\\h\\w*[\"']\\=,\\)
setlocal includeexpr=
setlocal indentexpr=GetRubyIndent(v:lnum)
setlocal indentkeys=0{,0},0),0],!^F,o,O,e,:,.,=end,=else,=elsif,=when,=ensure,=rescue,==begin,==end,=private,=protected,=public
setlocal noinfercase
setlocal iskeyword=@,48-57,_,192-255
setlocal keywordprg=ri
setlocal nolinebreak
setlocal nolisp
setlocal lispwords=
set list
setlocal list
setlocal listchars=
setlocal makeencoding=
setlocal makeprg=
setlocal matchpairs=(:),{:},[:]
setlocal modeline
setlocal modifiable
setlocal nrformats=bin,hex,alpha
set number
setlocal number
setlocal numberwidth=4
setlocal omnifunc=rubycomplete#Complete
setlocal path=/usr/local/Cellar/rbenv/1.2.0/rbenv.d/exec/gem-rehash,/Library/Ruby/Site/2.6.0,/Library/Ruby/Site/2.6.0/x86_64-darwin21,/Library/Ruby/Site/2.6.0/universal-darwin21,/Library/Ruby/Site,/System/Library/Frameworks/Ruby.framework/Versions/2.6/usr/lib/ruby/vendor_ruby/2.6.0,/System/Library/Frameworks/Ruby.framework/Versions/2.6/usr/lib/ruby/vendor_ruby/2.6.0/x86_64-darwin21,/System/Library/Frameworks/Ruby.framework/Versions/2.6/usr/lib/ruby/vendor_ruby/2.6.0/universal-darwin21,/System/Library/Frameworks/Ruby.framework/Versions/2.6/usr/lib/ruby/vendor_ruby,/System/Library/Frameworks/Ruby.framework/Versions/2.6/usr/lib/ruby/2.6.0,/System/Library/Frameworks/Ruby.framework/Versions/2.6/usr/lib/ruby/2.6.0/x86_64-darwin21,/System/Library/Frameworks/Ruby.framework/Versions/2.6/usr/lib/ruby/2.6.0/universal-darwin21
setlocal nopreserveindent
setlocal nopreviewwindow
setlocal quoteescape=\\
setlocal noreadonly
setlocal norelativenumber
setlocal norightleft
setlocal rightleftcmd=search
setlocal noscrollbind
setlocal scrolloff=-1
setlocal shiftwidth=2
setlocal noshortname
setlocal showbreak=
setlocal sidescrolloff=-1
set signcolumn=yes
setlocal signcolumn=yes
setlocal nosmartindent
setlocal softtabstop=0
setlocal nospell
setlocal spellcapcheck=[.?!]\\_[\\])'\"\	\ ]\\+
setlocal spellfile=
setlocal spelllang=en,cjk
setlocal spelloptions=
setlocal statusline=\ %t%m\ %y[%{&fenc},\ %{&ff}]\ %r%h%w\ %{coc#status()}%=%{GetCursorSyntax()}\ (%p%%)\ %l,%c\ =\ 0x%B\ |ﾟーﾟ)ﾉｨｮｩ\ 
setlocal suffixesadd=.rb
setlocal swapfile
setlocal synmaxcol=3000
if &syntax != 'ruby'
setlocal syntax=ruby
endif
setlocal tabstop=2
setlocal tagcase=
setlocal tagfunc=
setlocal tags=./tags,tags,/usr/local/Cellar/rbenv/1.2.0/rbenv.d/exec/gem-rehash/tags,/Library/Ruby/Site/2.6.0/tags,/Library/Ruby/Site/2.6.0/x86_64-darwin21/tags,/Library/Ruby/Site/2.6.0/universal-darwin21/tags,/Library/Ruby/Site/tags,/System/Library/Frameworks/Ruby.framework/Versions/2.6/usr/lib/ruby/vendor_ruby/2.6.0/tags,/System/Library/Frameworks/Ruby.framework/Versions/2.6/usr/lib/ruby/vendor_ruby/2.6.0/x86_64-darwin21/tags,/System/Library/Frameworks/Ruby.framework/Versions/2.6/usr/lib/ruby/vendor_ruby/2.6.0/universal-darwin21/tags,/System/Library/Frameworks/Ruby.framework/Versions/2.6/usr/lib/ruby/vendor_ruby/tags,/System/Library/Frameworks/Ruby.framework/Versions/2.6/usr/lib/ruby/2.6.0/tags,/System/Library/Frameworks/Ruby.framework/Versions/2.6/usr/lib/ruby/2.6.0/x86_64-darwin21/tags,/System/Library/Frameworks/Ruby.framework/Versions/2.6/usr/lib/ruby/2.6.0/universal-darwin21/tags
setlocal termwinkey=
setlocal termwinscroll=10000
setlocal termwinsize=
setlocal textwidth=120
setlocal thesaurus=
setlocal thesaurusfunc=
setlocal undofile
setlocal undolevels=-123456
setlocal varsofttabstop=
setlocal vartabstop=
setlocal virtualedit=
setlocal wincolor=
setlocal nowinfixheight
setlocal nowinfixwidth
set nowrap
setlocal nowrap
setlocal wrapmargin=0
let s:l = 1 - ((0 * winheight(0) + 24) / 49)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 1
normal! 0
tabnext 1
if exists('s:wipebuf') && len(win_findbuf(s:wipebuf)) == 0
  silent exe 'bwipe ' . s:wipebuf
endif
unlet! s:wipebuf
set winheight=1 winwidth=20 shortmess=filnxtToOSc
let s:sx = expand("<sfile>:p:r")."x.vim"
if filereadable(s:sx)
  exe "source " . fnameescape(s:sx)
endif
let &g:so = s:so_save | let &g:siso = s:siso_save
nohlsearch
doautoall SessionLoadPost
unlet SessionLoad
" vim: set ft=vim :
