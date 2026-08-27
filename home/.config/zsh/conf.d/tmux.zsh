# tmux は論理 $PWD を取得できないため、各ペインから表示名を渡す
function update_tmux_window_name() {
    [[ -n "$TMUX_PANE" ]] || return 0

    local automatic_rename
    local pane_active
    local parent="${PWD:h}"
    local window_name

    if [[ "$PWD" == "$HOME" ]]; then
        window_name='~'
    elif [[ "$parent" == "$HOME" ]]; then
        window_name="~/${PWD:t}"
    elif [[ "$parent" == / ]]; then
        window_name="$PWD"
    else
        window_name="${parent:t}/${PWD:t}"
    fi

    tmux set-option -p -t "$TMUX_PANE" @logical_window_name "$window_name" || return
    pane_active=$(tmux display-message -p -t "$TMUX_PANE" '#{pane_active}') || return
    [[ "$pane_active" == 1 ]] || return 0
    automatic_rename=$(tmux display-message -p -t "$TMUX_PANE" '#{automatic-rename}') || return
    [[ "$automatic_rename" == 1 ]] || return 0
    tmux rename-window -t "$TMUX_PANE" "$window_name" || return
    tmux set-option -w -t "$TMUX_PANE" automatic-rename on
}

autoload -Uz add-zsh-hook
add-zsh-hook chpwd update_tmux_window_name
update_tmux_window_name
