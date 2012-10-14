# 補完機能
autoload -Uz compinit
compinit

# 予測機能
#autoload -Uz predict-on
#predict-on

# 色機能
autoload -Uz colors
colors

# 色定義
local DEFAULT=$'%{^[[m%}'$
local RED=$'%{^[[1;31m%}'$
local GREEN=$'%{^[[1;32m%}'$
local YELLOW=$'%{^[[1;33m%}'$
local BLUE=$'%{^[[1;34m%}'$
local PURPLE=$'%{^[[1;35m%}'$
local LIGHT_BLUE=$'%{^[[1;36m%}'$
local WHITE=$'%{^[[1;37m%}'$


# プロンプトの設定
autoload -Uz vcs_info
autoload -Uz add-zsh-hook
zstyle ':vcs_info:*' enable git svn hg
zstyle ':vcs_info:*' stagedstr "+"
zstyle ':vcs_info:*' unstagedstr "-"
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
PS1="
%{$fg[cyan]%}     ∧ ∧
    (*ﾟーﾟ) %m:%~
    /  .|   %1v
～（＿＿ﾉ
%n${WINDOW:+"[$WINDOW]"}%# %{${reset_color}%}"

# エイリアスの設定
alias ls='ls -GFl'
alias man='jman'
alias screen='screen -U'
alias rm='gmv -f --backup=numbered --target-directory ~/.Trash'

export WORDCHARS='*?_.[]~=&;!#$%^(){}<>' #区切り文字
setopt list_packed #リストを詰めて表示
#ビープ音を鳴らさない
setopt nolistbeep
setopt nobeep
setopt auto_pushd #cdのときにpushdする

export __CF_USER_TEXT_ENCODING="0x1F5:0x08000100:14" #fakeclipの設定

stty stop undef #C-s の無効化

# 補完候補の色づけ
eval `gdircolors`
export ZLS_COLORS=$LS_COLORS
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:messages' format %{$fg[yellow]%}'%d'format %{${reset_color}%}
zstyle ':completion:*:warnings' format %{$fg[red]%}'No matches for:'%{$fg[yellow]%}' %d'%{${reset_color}%}
zstyle ':completion:*:descriptions' format %{$fg[yellow]%}'%B%d%b'%{${reset_color}%}
zstyle ':completion:*:corrections' format %{$fg[yellow]%}'%B%d '%{$fg[red]%}'(errors: %e)%b'%{${reset_color}%}

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
#setopt glob_dots #ドットファイルも普通のファイルと同様に扱う

# スクリーンで開始する
if [ $SHLVL = 1 ]; then
    screen -R
fi

