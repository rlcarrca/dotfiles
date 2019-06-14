#!/bin/bash

# Functions and aliases.
# https://github.com/rlcarrca/dotfiles

alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'
alias lower="tr '[:upper:]' '[:lower:]'"
alias upper="tr '[:lower:]' '[:upper:]'"

if [[ $OSTYPE == darwin* ]]; then
    alias ls='ls -G'
else
    alias ls='ls --color=auto'
fi

function dcd {
    cd "$(dirname "$1")"
}

function _rlcarrca_run_once {
    echo -e "\\033[36m=> INFO: Setting git configs.\\033[0m"
    git config --global alias.exec '!exec '
    git config --global color.ui true
    git config --global core.editor vim
    git config --global core.excludesfile ~/.gitignore
    git config --global diff.tool vimdiff
    git config --global merge.tool vimdiff
    git config --global rerere.enabled true
    git config --global user.email robertlcarr@gmail.com
    git config --global user.name "Robert Carr"
    echo $'.DS_Store\n.idea/\nvenv/\n.venv/' > ~/.gitignore
    # Build diff-highlight.
    local file_path; file_path="$(find /usr -type f -name diff-highlight 2>/dev/null |head -1)"
    if [ -z "$file_path" ]; then
        dir_path="$(find /usr -type d -name diff-highlight 2>/dev/null |head -1)"
        if [ -f "$dir_path/Makefile" ]; then
            echo Need root to build diff-highlight
            sudo make -C "$dir_path" && file_path="$dir_path/diff-highlight"
        fi
    fi
    if [ -f "$file_path" ]; then
        echo -e "\\033[36m=> INFO: Enabling diff-highlight.\\033[0m"
        git config --global pager.diff "perl $file_path |less"
        git config --global pager.show "perl $file_path |less"
        git config --global pager.log "perl $file_path |less"
    else
        echo -e "\\033[33m=> WARNING: Can't find diff-highlight.\\033[0m"
    fi
}
