() {
    local src
    for src in $ZDOTDIR/conf.d/*.zsh; do
        source $src
    done
}

if [ -f ~/.local/zshrc ]; then
    source ~/.local/zshrc
fi

# tmuxで開始する
if (type -p tmux >/dev/null 2>&1) && [[ $SHLVL -le 1 && ! $TERM =~ "^screen.*" ]]; then
    if $(tmux has-session); then
        tmux attach
    else
        tmux new-session -d
        if [[ -d ~/Note ]]; then
            tmux send-keys 'cd ~/Note && vim' Enter \; new-window
        fi
        if [[ -d ~/Memo ]]; then
            tmux send-keys 'cd ~/Memo && vim' Enter \; new-window
        fi
        tmux attach
    fi
fi
