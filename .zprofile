alias ls='ls -Fl'
if type brew >/dev/null 2>&1; then
    libexec="$(brew --prefix coreutils)/libexec"
    if [ -d $libexec ]; then
        export PATH=$libexec/gnubin:$PATH
        export MANPATH=$libexec/gnuman:$MANPATH
    fi
fi

