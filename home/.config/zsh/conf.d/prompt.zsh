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

    function update_prompt_data() {
        psvar=()
        LANG=en_US.UTF-8 vcs_info
        if [[ -n "$vcs_info_msg_0_" ]]; then
            psvar[1]="$vcs_info_msg_0_"
        fi

        docker_context=$(docker context show 2>/dev/null)
        if [[ -n "$docker_context" && "$docker_context" != "default" ]]; then
            psvar[2]="docker: $docker_context"
        fi
    }

    add-zsh-hook precmd update_prompt_data
fi

function change_prompt() {
    local aa_color="%{[38;5;${PROMPT_AA_COLOR:-69}m%}"
    local prompt_color
    if [[ $UID -eq 0 ]]; then
        prompt_color="%{[38;5;197m%}"
    else
        prompt_color=""
    fi

    local simple_prompt
    simple_prompt="
%# "

    local c_prompt
    c_prompt="$aa_color
     ∧  ∧   %2v
    (*ﾟーﾟ) %m:%~
    /  .|   %1v
～（＿＿ﾉ
%n${WINDOW:+"[$WINDOW]"}$prompt_color%# %{[0m%}"

    if [ $PS1 = $c_prompt ]; then
        PS1=$simple_prompt
    else
        PS1=$c_prompt
    fi
}

change_prompt

