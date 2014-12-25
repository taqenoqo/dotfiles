autoload -Uz is-at-least
if is-at-least 4.3.10; then
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
        aaColor="%{[38;5;173m%}"
        ;;
    "tak3n0k0" )
        aaColor="%{[38;5;26m%}"
        ;;
    abelia[0-5][0-9] | borage[0-5][0-9] | crocus[0-5][0-9] )
        aaColor="%{[38;5;163m%}"
        ;;
    * )
        aaColor="%{[38;5;244m%}"
        echo $(hostname -s)
        ;;
esac
if [[ $UID -eq 0 ]]; then
    promptColor="%{[38;5;197m%}"
else
    promptColor=""
fi

function change_prompt() {
    simplePrompt="%# "
    cPrompt="
$aaColor     ∧ ∧
    (*ﾟーﾟ) %m:%~
    /  .|   %1v
～（＿＿ﾉ
%n${WINDOW:+"[$WINDOW]"}$promptColor%# %{[38;5;00m%}"
    if [ $PS1 = $cPrompt ]; then
        PS1=$simplePrompt
    else
        PS1=$cPrompt
    fi
}
change_prompt

