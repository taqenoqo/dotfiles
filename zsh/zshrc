fpath=(~/.zsh/functions $fpath)

# 補完機能
autoload -Uz compinit
compinit

source ~/.zsh/c_prompt.zsh
source ~/.zsh/completion.zsh
source ~/.zsh/aliases.zsh

export WORDCHARS='*?_.[]~=&;!#$%^(){}<>' #区切り文字
setopt list_packed #リストを詰めて表示
setopt auto_pushd #cdのときにpushdする
stty stop undef #C-s の無効化

# ビープ音を鳴らさない
setopt nolistbeep
setopt nobeep

bindkey -e #emacs的キーバインド

setopt glob #グロブ
setopt extendedglob #拡張グロブ

setopt auto_cd #ディレクトリ名を打つと自動でcd

if [ -f ~/.zshrc.local ]; then
    source ~/.zshrc.local
fi

# tmuxで開始する
if (type -p tmux >/dev/null 2>&1) && [ $SHLVL -le 1 -a $TERM != "screen" ]; then
    if $(tmux has-session); then
        tmux attach
    else
        tmux
    fi
fi

