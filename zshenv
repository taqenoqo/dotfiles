export EDITOR=vim
export LANG=ja_JP.UTF-8

if [ -f ~/.zshenv.local ]; then
    source ~/.zshenv.local
fi

if [ -e "/usr/local/share/zsh-completions" ]; then
    FPATH="/usr/local/share/zsh-completions:$FPATH"
fi

if (brew --version >/dev/null 2>&1); then
    export PATH="$(brew --prefix)/sbin:$PATH"
    libexec="$(brew --prefix coreutils)/libexec"
    if [ -d $libexec ]; then
        export PATH=$libexec/gnubin:$PATH
        export MANPATH=$libexec/gnuman:$MANPATH
    fi
fi

if (rbenv --version >/dev/null 2>&1); then
    eval "$(rbenv init -)"
    if (brew --version >/dev/null 2>&1); then
        source "`brew --prefix rbenv`/completions/rbenv.zsh"
    fi
fi

if (nodebrew --version >/dev/null 2>&1); then
    export PATH=$HOME/.nodebrew/current/bin:$PATH
fi

