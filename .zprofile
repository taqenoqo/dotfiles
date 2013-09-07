alias ls='ls -Fl'
if type brew >/dev/null 2>&1; then
    libexec="$(brew --prefix coreutils)/libexec"
    if [ -d $libexec ]; then
        export PATH=$libexec/gnubin:$PATH
        export MANPATH=$libexec/gnuman:$MANPATH
    fi
fi

if type rbenv >/dev/null 2>&1; then
    eval "$(rbenv init -)"
    if type brew >/dev/null 2>&1; then
        source "`brew --prefix rbenv`/completions/rbenv.zsh"
    fi
fi
