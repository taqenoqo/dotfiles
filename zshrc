() {
    local src
    for src in $HOME/.zshrc.d/*.zsh; do
        source $src
    done
}

if [ -f ~/.zshrc.local ]; then
    source ~/.zshrc.local
fi

# tmuxで開始する
if (type -p tmux >/dev/null 2>&1) && [ $SHLVL -le 1 -a $TERM != "screen" ]; then
    if $(tmux has-session); then
        tmux attach
    else
        tmux new-session -d 'cd ~/Memo && vim' \; new-window \; attach
    fi
fi

# OPAM configuration
. /Users/takenoko/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
