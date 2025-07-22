#!/usr/bin/env bash

function xini {
    if [ $(tmux has-session -t main) == 0 ]; then
	tmux attach -t main
    else
	tmux new -s main
    fi
}

function xls {
    tmux ls -F 
}
