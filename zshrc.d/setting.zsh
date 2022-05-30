autoload -Uz run-help
autoload -Uz run-help-git
autoload -Uz run-help-openssl
autoload -Uz run-help-sudo

export WORDCHARS='*?_.[]~=&;!#$%^(){}<>' #区切り文字
setopt list_packed #リストを詰めて表示
setopt auto_pushd #cdのときにpushdする
stty stop undef #C-s の無効化

# ビープ音を鳴らさない
setopt nolistbeep
setopt nobeep

bindkey -v # vim風キーバインド
bindkey -v '^?' backward-delete-char
bindkey -v '^a' beginning-of-line
bindkey -v '^e' end-of-line
bindkey -v '^p' up-line-or-history
bindkey -v '^n' down-line-or-history
bindkey -v '^_' run-help
bindkey -v '^y' history-search-forward
bindkey -v '^h' history-search-backward

setopt glob #グロブ
setopt extendedglob #拡張グロブ

setopt auto_cd #ディレクトリ名を打つと自動でcd


