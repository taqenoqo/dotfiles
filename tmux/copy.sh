#!/bin/zsh

if type -p tmux >/dev/null 2>&1; then
    if type -p pbcopy >/dev/null 2>&1; then
        tmux save-buffer - | pbcopy
    elif type -p xclip >/dev/null 2>&1; then
        tmux save-buffer - | xclip -selection c
    fi
fi

