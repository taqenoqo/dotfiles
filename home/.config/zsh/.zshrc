() {
    local src
    for src in $ZDOTDIR/conf.d/*.zsh; do
        source $src
    done
}

if [ -f "$ZDOTDIR/.zshrc.local" ]; then
    source "$ZDOTDIR/.zshrc.local"
fi

# tmux の new-window -e で渡されたコマンドを初期化後に実行する。子シェルで再実行しないよう消す
if [[ -n $STARTUP_COMMAND ]]; then
    startup_command=$STARTUP_COMMAND
    unset STARTUP_COMMAND
    eval "$startup_command"
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
            tmux_commands+=(new-window -a -c ~/Note -e STARTUP_COMMAND=vim \;)
        fi
        if [[ -d ~/Memo ]]; then
            tmux_commands+=(new-window -a -c ~/Memo -e STARTUP_COMMAND=vim \;)
        fi
        tmux_commands+=(
            select-window -t "$window_id" \;
            new-window -c '#{pane_current_path}' \;
            kill-window -t "$window_id"
        )
        tmux "${tmux_commands[@]}"
    fi
fi
