if [ -x /usr/libexec/path_helper ]; then
    export PATH=''
    eval `/usr/libexec/path_helper -s`
fi

export EDITOR=vim
export LANG=ja_JP.UTF-8

if [ -e "/usr/local/share/zsh-completions" ]; then
    FPATH="/usr/local/share/zsh-completions:$FPATH"
fi

if [ -x "/opt/homebrew/bin/brew" ]; then
  eval $(/opt/homebrew/bin/brew shellenv)
fi

if (command -v brew >/dev/null 2>&1); then
    local brew_dir="$(brew --prefix)"
    
    if [ -d "$brew_dir/opt/coreutils/libexec" ]; then
        local libexec="$brew_dir/opt/coreutils/libexec"
        export PATH=$libexec/gnubin:$PATH
        export MANPATH=$libexec/gnuman:$MANPATH
    fi

    if [ -d "$brew_dir/opt/grep/libexec" ]; then
        local libexec="$brew_dir/opt/grep/libexec"
        export PATH=$libexec/gnubin:$PATH
        export MANPATH=$libexec/gnuman:$MANPATH
    fi

    if [ -d "$brew_dir/opt/gnu-sed/libexec" ]; then
        local libexec="$brew_dir/opt/gnu-sed/libexec"
        export PATH=$libexec/gnubin:$PATH
        export MANPATH=$libexec/gnuman:$MANPATH
    fi

    if [ -d "$brew_dir/opt/openjdk" ]; then
        local openjdk="$brew_dir/opt/openjdk"
        export PATH="$openjdk/bin:$PATH"
        export CPPFLAGS="-I$openjdk/include"
    fi

    if [ -x "$brew_dir/bin/asdf" ]; then
        source "$brew_dir/opt/asdf/libexec/asdf.sh"
    fi
fi

if [[ -f "$HOME/.asdf/plugins/java/set-java-home.zsh" ]]; then
    . "$HOME/.asdf/plugins/java/set-java-home.zsh"
fi

if (command -v anyenv >/dev/null 2>&1); then
    eval "$(anyenv init -)"
fi

if (command -v rbenv >/dev/null 2>&1); then
    eval "$(rbenv init - zsh)"
fi

if (command -v jenv >/dev/null 2>&1); then
    export PATH="$HOME/.jenv/bin:$PATH"
    eval "$(jenv init -)"
fi

if (type -p nodebrew >/dev/null 2>&1); then
    export PATH="$HOME/.nodebrew/current/bin:$PATH"
fi

#if (type -p stack >/dev/null 2>&1); then
#    export PATH="$(stack path --compiler-bin):$PATH"
#    export PATH="$(stack path --local-bin):$PATH"
#fi

if (command -v opam >/dev/null 2>&1); then
    source "$HOME/.opam/opam-init/init.zsh"
fi

if (command -v direnv >/dev/null 2>&1); then
    eval "$(direnv hook zsh)"
fi

if (command -v delta >/dev/null 2>&1); then
    export GH_PAGER="delta"
fi

if (command -v gh >/dev/null 2>&1); then
    export GLAMOUR_STYLE="light"
fi

if [ -f "$HOME/.ghcup/env" ]; then
    source "$HOME/.ghcup/env"
fi

export PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH"

export PATH="$HOME/.local/bin:$PATH"
export FPATH="$HOME/.local/completion:$FPATH"

if [ -f ~/.local/zprofile ]; then
    source ~/.local/zprofile
fi

