if ls --version >/dev/null 2>&1; then
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

alias copilot='copilot \
    --add-dir "$HOME/.copilot/installed-plugins" \
    --add-dir "$HOME/.copilot/skills" \
    --add-dir "$HOME/.config/ai" \
    --add-dir "$HOME/dotfiles/" \
    --add-dir "/tmp" \
    --allow-tool="shell(mkdir)" \
    --allow-tool="shell(echo)" \
    --allow-tool="shell(printf)" \
    --allow-tool="shell(test)" \
    --allow-tool="shell(find)" \
    --allow-tool="shell(sed)" \
    --allow-tool="shell(npm)" \
    --allow-tool="shell(npm test)" \
    --allow-tool="shell(jq)" \
    --allow-tool="shell(git add)" \
    --allow-tool="shell(git mv)" \
    --allow-tool="shell(git rm)" \
    --allow-tool="shell(git commit)" \
    --allow-tool="shell(git status)" \
    --allow-tool="shell(git show)" \
    --allow-tool="shell(git log)" \
    --allow-tool="shell(git pull)" \
    --allow-tool="shell(git fetch)" \
    --allow-tool="shell(git check-ignore)" \
    --allow-tool="shell(git worktree)" \
    --allow-tool="shell(git checkout)" \
    --allow-tool="shell(git restore)" \
    --allow-tool="shell(git merge-base)" \
    --allow-tool="shell(git ls-tree)" \
    --allow-tool="shell(node)" \
    --allow-tool="shell(python)" \
    --allow-tool="shell(python3)" \
    --allow-tool="write"'
