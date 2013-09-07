#!/bin/zsh

if type tmux >/dev/null 2>&1; then
    if type reattach-to-user-namespace >/dev/null 2>&1; then
        tmux save-buffer - | reattach-to-user-namespace pbcopy
    else
        tmux save-buffer - | pbcopy
    fi
fi

