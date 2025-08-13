if ls --color >/dev/null 2>&1; then
    alias ls='ls -Flh -N --color=auto --time-style +%Y-%m-%d\ %H:%M --group-directories-first'
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

alias :q='exit'

if type -p thefuck >/dev/null 2>&1; then
    eval $(thefuck --alias)
fi

alias stbuild='stack build'
alias stghci='stack ghci'
alias stexec='stack exec'
alias sthoogle='stack hoogle -- --color'
alias stdoc='() { stack hoogle -- --color --info $@ | less -R }'

