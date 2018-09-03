set runtimepath+=~/.vim/dein.vim

let s:script_dir = expand('<sfile>:p:h')

if dein#load_state('~/.dein')
    call dein#begin('~/.dein')

    call dein#load_toml(s:script_dir . '/plugins.toml')

    call dein#end()
    call dein#save_state()
endif

if dein#check_install()
  call dein#install()
endif

filetype plugin indent on

