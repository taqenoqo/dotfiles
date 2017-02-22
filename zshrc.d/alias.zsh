if ls --color >/dev/null 2>&1; then
    alias ls='ls -Flh -N --color=auto --time-style +%Y-%m-%d\ %H:%M'
elif ls -G >/dev/null 2>&1; then
    alias ls='ls -GFlh'
fi

alias tmux='tmux -2'

alias up='cd ..'

if type rmtrash >/dev/null 2>&1; then
    alias rm='rmtrash'
else
    alias rm='rm -i'
fi

alias df='df -h'

alias be='bundle exec'

alias back='popd'

if type colordiff >/dev/null 2>&1; then
    alias diff='colordiff'
fi

alias emacs='vim'

