#!/bin/zsh

if type -p tmux >/dev/null 2>&1; then
    if type -p reattach-to-user-namespace >/dev/null 2>&1; then
        tmux save-buffer - | reattach-to-user-namespace pbcopy
    else
        tmux save-buffer - | pbcopy
    fi
fi

