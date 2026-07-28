# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# VCS-aware prompt (https://github.com/meadowface/bash-prompt-vcs)
if [ -f $HOME/.bash-prompt-vcs.bash ]; then
    . $HOME/.bash-prompt-vcs.bash
    export PS1="\u@\h:\w\$(bpvcs_bash_prompt)\$ "
fi

export LANG=en_US.utf-8
export LC_ALL="$LANG"
export EDITOR=nvim

# Disable flow control (frees up Ctrl-S/Ctrl-Q)
stty -ixoff
stty -ixon

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

alias tmux='TERM=xterm-256color tmux'

# Compiler switching (gcc/clang)
export COMPILER_FILE=$HOME/.config/compiler

# Note: this might not work or be needed
function compiler {
    case "$1" in
        'gcc')
            export CC=gcc
            export CXX=g++
            export BUILD_DIR=build
            ;;
        'clang')
            export CC=clang
            export CXX=clang++
            export BUILD_DIR=build.clang
            ;;
         *)
            echo "unsupported compiler"
            return 1
    esac
    if [ -z "$2" ]; then
        echo "$1" > $COMPILER_FILE
    fi
}

if [ -f "$COMPILER_FILE" ]; then
    compiler $(cat $COMPILER_FILE) false
fi

export PATH=~/usr/bin:$PATH

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
