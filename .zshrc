# 補完機能
autoload -Uz compinit
compinit

# 色機能
autoload -Uz colors
colors

autoload -Uz is-at-least

# プロンプトの設定
if is-at-least 4.3.11; then
    autoload -Uz vcs_info
    autoload -Uz add-zsh-hook
    zstyle ':vcs_info:*' enable git svn hg
    zstyle ':vcs_info:*' stagedstr '+'
    zstyle ':vcs_info:*' unstagedstr '-'
    zstyle ':vcs_info:*' formats '%s %b %c%u'
    zstyle ':vcs_info:*' actionformats '%s %b [%a] %c%u'
    zstyle ':vcs_info:*' branchformat '%b:%r'
    zstyle ':vcs_info:*' use-simple true
    zstyle ':vcs_info:*' check-for-changes true
    function updateMessage() {
        psvar=()
        LANG=en_US.UTF-8 vcs_info
        if [[ -n "$vcs_info_msg_0_" ]]; then
            psvar[1]="$vcs_info_msg_0_"
        fi
    }
    add-zsh-hook precmd updateMessage
fi
case $(hostname -s) in
    "TakenokoMacintosh" )
        promptColor="%{[38;5;173m%}"
        ;;
    "tak3n0k0" )
        promptColor="%{[38;5;26m%}"
        ;;
    acacia[0-5][0-9] | burnet[0-5][0-9] | cosmos[0-5][0-9] )
        promptColor="%{[38;5;163m%}"
        ;;
    * )
        promptColor="%{[38;5;244m%}"
        echo $(hostname -s)
        ;;
esac
PS1="
$promptColor     ∧ ∧
    (*ﾟーﾟ) %m:%~
    /  .|   %1v
～（＿＿ﾉ
%n${WINDOW:+"[$WINDOW]"}%# %{${reset_color}%}"

export WORDCHARS='*?_.[]~=&;!#$%^(){}<>' #区切り文字
setopt list_packed #リストを詰めて表示
setopt auto_pushd #cdのときにpushdする
stty stop undef #C-s の無効化

# ビープ音を鳴らさない
setopt nolistbeep
setopt nobeep

# 補完候補の色づけ
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

setopt glob #ファイルグロブ
setopt extendedglob #拡張グロブ

# エイリアスの設定
if ls --color >/dev/null 2>&1; then
    alias ls='ls -Flh --color=auto'
elif ls -G >/dev/null 2>&1; then
    alias ls='ls -GFlh'
fi
alias tmux='tmux -2'
alias up='cd ..'
if type rmtrash >/dev/null 2>&1; then
    alias rm='rmtrash'
else
    alias rm='rm -i'
fi
alias df='df -h'
alias be='bundle exec'
alias back='popd'

# tmuxで開始する
if (type -p tmux >/dev/null 2>&1) && [ $SHLVL = 1 ]; then
    if $(tmux has-session); then
        tmux attach
    else
        tmux
    fi
fi

