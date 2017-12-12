if ls --color >/dev/null 2>&1; then
    alias ls='ls -Flh -N --color=auto --time-style +%Y-%m-%d\ %H:%M'
elif ls -G >/dev/null 2>&1; then
    alias ls='ls -GFlh'
fi

alias cp='cp -i'

alias mv='mv -i'

alias ln='ln -i'

if type -p rmtrash >/dev/null 2>&1; then
    alias rm='rmtrash'
else
    alias rm='rm -i'
fi

alias tmux='tmux -2'

alias df='df -h'

if type -p colordiff >/dev/null 2>&1; then
    alias diff='colordiff'
fi

alias up='cd ..'

alias be='bundle exec'

alias back='popd'

