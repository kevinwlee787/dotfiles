#!/usr/bin/env bash
# Works as either ~/.bashrc or ~/.bashrc.user; install.sh picks. Where a
# managed ~/.bashrc already set a PS1, this runs after it and wins.

# /etc/bashrc guards itself with BASHRCSOURCED, so this is a no-op when a
# managed ~/.bashrc has already done it.
if [ -f /etc/bashrc ]; then
    # shellcheck source=/dev/null
    . /etc/bashrc
fi

export LANG=en_US.utf-8
export LC_ALL="$LANG"
export EDITOR=nvim

# Free up Ctrl-S/Ctrl-Q. Needs a tty; sshd sources this non-interactively.
if [[ $- == *i* ]]; then
    stty -ixoff
    stty -ixon
fi

[[ -d "${HOME}/usr/bin" ]] && export PATH="${HOME}/usr/bin:${PATH}"

alias tmux='TERM=xterm-256color tmux'

# Refresh tmux environment variables in current shell
function tmup() {
    echo -n "Updating to latest tmux environment...";
    export IFS=",";
    for line in $(tmux showenv -t $(tmux display -p "#S") | tr "\n" ",");
    do
        if [[ $line == -* ]]; then
            unset $(echo $line | cut -c2-);
        else
            export "$line";
        fi;
    done;
    unset IFS;
    echo "Done"
}

# Show version control state in the prompt.
# The backslash in \$(bpvcs_bash_prompt) is required: it defers the call to
# each prompt render instead of running it once, here.
if [[ -r "${HOME}/.bash-prompt-vcs.bash" ]]; then
    # shellcheck source=/dev/null
    source "${HOME}/.bash-prompt-vcs.bash"
    PS1="\u@\h:\w\$(bpvcs_bash_prompt)\$ "
fi

# fzf key bindings and completion:
#   Ctrl-R  fuzzy search command history
#   Ctrl-T  insert a file path at the cursor
#   Alt-C   cd into a subdirectory
if command -v fzf >/dev/null 2>&1; then
    eval "$(fzf --bash)"
elif [[ -r "${HOME}/.fzf.bash" ]]; then
    # shellcheck source=/dev/null
    source "${HOME}/.fzf.bash"
fi

if [[ -r "${HOME}/.bashrc.user.local" ]]; then
    # shellcheck source=/dev/null
    source "${HOME}/.bashrc.user.local"
fi

# Flush per command; bash otherwise only writes history on a clean exit.
PROMPT_COMMAND="history -a${PROMPT_COMMAND:+; ${PROMPT_COMMAND}}"
