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
zstyle ':completion:*:default' menu yes select=0 interactive #補完候補のカーソル選択
zstyle ':completion:*' group-name '' #補完グループの表示
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*' verbose yes
zstyle ':completion:*' completer _oldlist _complete  _expand _match _prefix _approximate _list _history
zstyle ':completion:*' insert-unambiguous true
zstyle ':completion:*' use-cache true
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters #変数の添字補完
zstyle ':completion:*' list-separator ':' #セパレータ文字
zstyle ':completion:*:manuals' separate-sections true #manの補完をセクションごとに

zmodload zsh/complist
bindkey '^n' down-line-or-history
bindkey '^p' up-line-or-history
bindkey '^w' backward-kill-word
bindkey -M menuselect '^n' down-line-or-history
bindkey -M menuselect '^p' up-line-or-history
bindkey -M menuselect '^f' forward-char
bindkey -M menuselect '^b' backward-char
bindkey -M menuselect '^j' down-line-or-history
bindkey -M menuselect '^k' up-line-or-history
bindkey -M menuselect '^l' forward-char
bindkey -M menuselect '^h' backward-char
bindkey -M menuselect '\t' down-line-or-history
bindkey -M menuselect '\e[Z' up-line-or-history
bindkey -M menuselect '^e' send-break
bindkey -M menuselect '^w' backward-kill-word

fpath=(/usr/local/share/zsh-completions $fpath) # zsh-completions

