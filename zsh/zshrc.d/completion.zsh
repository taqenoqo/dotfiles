() {
    autoload -Uz colors
    colors

    autoload -Uz compinit
    compinit

    if type dircolors >/dev/null 2>&1; then
        eval `dircolors`
    fi

    export ZLS_COLORS=$LS_COLORS
    zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
    zstyle ':completion:*:messages' format %{$fg[yellow]%}'%d'format %{${reset_color}%}
    zstyle ':completion:*:warnings' format %{$fg[red]%}'見つからないの'%{${reset_color}%}
    zstyle ':completion:*:descriptions' format %{$fg[yellow]%}'%B%d%b'%{${reset_color}%}
    zstyle ':completion:*:corrections' format %{$fg[yellow]%}'%B%d '%{$fg[red]%}'(不一致: %e文字)%b'%{${reset_color}%}
    zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' #大小文字を区別せずに補完
    zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin #sudoでも補完する
    zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([%0-9]#)*=0=01;31' #プロセス番号とジョブの色付け
    zstyle ':completion:*:default' menu yes select=0 #補完候補のカーソル選択
    zstyle ':completion:*' group-name '' #補完グループの表示
    zstyle ':completion:*:options' description 'yes'
    zstyle ':completion:*' verbose yes
    zstyle ':completion:*' completer _oldlist _complete  _expand _match _prefix _approximate _list _history
    zstyle ':completion:*' insert-unambiguous true
}

