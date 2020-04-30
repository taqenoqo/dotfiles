export EDITOR=vim
export LANG=ja_JP.UTF-8

if [ -f ~/.zshenv.local ]; then
    source ~/.zshenv.local
fi

if [ -e "/usr/local/share/zsh-completions" ]; then
    FPATH="/usr/local/share/zsh-completions:$FPATH"
fi

if (type -p brew >/dev/null 2>&1); then
    export PATH="$(brew --prefix)/sbin:$PATH"
    () {
        local libexec="/usr/local/opt/coreutils/libexec"
        if [ -d $libexec ]; then
            export PATH=$libexec/gnubin:$PATH
            export MANPATH=$libexec/gnuman:$MANPATH
        fi
    }
fi

if (type -p rbenv >/dev/null 2>&1); then
    eval "$(rbenv init -)"
    () {
        local rbenv_completion="/usr/local/opt/coreutils/libexec/completions/rbenv.zsh"
        if [ -r $rbenv_completion ]; then
            source "$rbenv_completion"
        fi
    }
fi

if (type -p nodebrew >/dev/null 2>&1); then
    export PATH="$HOME/.nodebrew/current/bin:$PATH"
fi

if (type -p stack >/dev/null 2>&1); then
    export PATH="$(stack path --compiler-bin):$PATH"
    export PATH="$(stack path --local-bin):$PATH"
fi

if (type -p opam >/dev/null 2>&1); then
    source "$HOME/.opam/opam-init/init.zsh"
fi

if (type -p direnv >/dev/null 2>&1); then
    eval "$(direnv hook zsh)"
fi

export PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH"

