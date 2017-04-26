export WORDCHARS='*?_.[]~=&;!#$%^(){}<>' #区切り文字
setopt list_packed #リストを詰めて表示
setopt auto_pushd #cdのときにpushdする
stty stop undef #C-s の無効化

# ビープ音を鳴らさない
setopt nolistbeep
setopt nobeep

bindkey -v #emacs的キーバインド
bindkey -v '^?' backward-delete-char

setopt glob #グロブ
setopt extendedglob #拡張グロブ

setopt auto_cd #ディレクトリ名を打つと自動でcd

