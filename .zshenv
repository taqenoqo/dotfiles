export EDITOR=vim

export LANG=ja_JP.UTF-8

if [ -f ~/.zshenv.local ]; then
    source ~/.zshenv.local
fi

if (type brew >/dev/null 2>&1) && (brew --version >/dev/null 2>&1); then
    libexec="$(brew --prefix coreutils)/libexec"
    if [ -d $libexec ]; then
        export PATH=$libexec/gnubin:$PATH
        export MANPATH=$libexec/gnuman:$MANPATH
    fi
fi

if (type rbenv >/dev/null 2>&1) && (rbenv --version >/dev/null 2>&1); then
    eval "$(rbenv init -)"
    if (type brew >/dev/null 2>&1) && (brew --version >/dev/null 2>&1); then
        source "`brew --prefix rbenv`/completions/rbenv.zsh"
    fi
fi

