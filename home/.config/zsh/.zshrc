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
        window_id=$(tmux display-message -p '#{window_id}')
        tmux_commands=(attach \;)
        if [[ -d ~/Note ]]; then
            tmux_commands+=(
                smart-new-window \;
                setw synchronize-panes on \;
                send-keys 'cd ~/Note' Enter \;
                setw synchronize-panes off \;
                send-keys vim Enter \;
            )
        fi
        if [[ -d ~/Memo ]]; then
            tmux_commands+=(
                smart-new-window \;
                setw synchronize-panes on \;
                send-keys 'cd ~/Memo' Enter \;
                setw synchronize-panes off \;
                send-keys vim Enter \;
            )
        fi
        tmux_commands+=(
            select-window -t "$window_id" \;
            smart-new-window \;
            kill-window -t "$window_id"
        )
        tmux "${tmux_commands[@]}"
    fi
fi
