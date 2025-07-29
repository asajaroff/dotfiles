#!/usr/bin/env bash

function tmuxmain {
    if [ $(tmux has-session -t main) -eq 0 ]; then
	tmux attach -t main
    else
	tmux new -s main
    fi
}

function xls {
    tmux ls -F 
}