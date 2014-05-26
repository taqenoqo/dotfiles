autoload -Uz is-at-least
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
    abelia[0-5][0-9] | borage[0-5][0-9] | crocus[0-5][0-9] )
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
%n${WINDOW:+"[$WINDOW]"}%# %{[38;5;00m%}"

