export EDITOR=vim
export LANG=ja_JP.UTF-8

if [ -f ~/.zshenv.local ]; then
    source ~/.zshenv.local
fi

if [ -e "/usr/local/share/zsh-completions" ]; then
    FPATH="/usr/local/share/zsh-completions:$FPATH"
fi

if (type brew >/dev/null 2>&1); then
    export PATH="$(brew --prefix)/sbin:$PATH"
    () {
        local libexec="/usr/local/opt/coreutils/libexec"
        if [ -d $libexec ]; then
            export PATH=$libexec/gnubin:$PATH
            export MANPATH=$libexec/gnuman:$MANPATH
        fi
    }
fi

if (type rbenv >/dev/null 2>&1); then
    eval "$(rbenv init -)"
    () {
        local rbenv_completion="/usr/local/opt/coreutils/libexec/completions/rbenv.zsh"
        if [ -r $rbenv_completion ]; then
            source "$rbenv_completion"
        fi
    }
fi

if (nodebrew --version >/dev/null 2>&1); then
    export PATH=$HOME/.nodebrew/current/bin:$PATH
fi

