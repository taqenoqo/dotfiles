FPATH="$HOME/.zsh/completion/:$FPATH"

autoload -Uz colors
colors

autoload bashcompinit
bashcompinit

autoload -Uz compinit
compinit

if command -v dircolors >/dev/null 2>&1; then
    eval `dircolors`
fi

export ZLS_COLORS=$LS_COLORS
zstyle ':completion:*' completer _expand _complete _history _external_pwds
zstyle ':completion:*' use-cache true                                                                   # キャッシュの有効化
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'                                               # 通常の補完に失敗した場合大小文字を区別せずに補完
zstyle ':completion:*' group-name ''                                                                    # 補完グループ名の表示 (タグ名による表示)
zstyle ':completion:*' list-separator ':'                                                               # 補完文字と説明文の区切り文字
zstyle ':completion:*' verbose true                                                                     # 保管を冗長表示
zstyle ':completion:*' insert-unambiguous true                                                          # _approximate にて、誤字が曖昧ではなければメニューを出さずに挿入する
zstyle ':completion:*' menu true interactive no-select                                                  # 補完候補のカーソル選択
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}                                                   # GNU ls コマンドと同じ色使いに
zstyle ':completion:*:options' description yes
zstyle ':completion:*:messages' format %{$fg[yellow]%}'%d'format %{${reset_color}%}
zstyle ':completion:*:warnings' format %{$fg[red]%}'見つからないよ!'%{${reset_color}%}
zstyle ':completion:*:descriptions' format %{$fg[yellow]%}'%B%d%b'%{${reset_color}%}
zstyle ':completion:*:corrections' format %{$fg[yellow]%}'%B%d '%{$fg[red]%}'(不一致: %e文字)%b'%{${reset_color}%} 
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin # sudoでも補完する
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters                                     # 変数の添字補完
zstyle ':completion:*:manuals' separate-sections true                                                   # manの補完をセクションごとに

zmodload zsh/complist # menuselect の bindkey のための mod
bindkey '\t' menu-expand-or-complete
bindkey '^n' down-line-or-history
bindkey '^p' up-line-or-history
bindkey '^w' backward-kill-word
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect '\t' down-line-or-history
bindkey -M menuselect '\e[Z' up-line-or-history
bindkey -M menuselect '^e' send-break
bindkey -M menuselect '^[' send-break
bindkey -M menuselect '^w' backward-kill-word

if command -v fzf >/dev/null 2>&1; then
    bindkey "^R" fzf-history-widget
    bindkey "^F" fzf-file-widget
fi


if command -v aws_completer >/dev/null 2>&1; then
    complete -C "$(which aws_completer)" aws
fi

