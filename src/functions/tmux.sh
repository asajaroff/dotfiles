#!/usr/bin/env bash
# Name: tmux session handlers

function df_tmux_session() {
    if [[ -n "${TMUX_SESSION_NAME}" ]]; then
	echo "Using ${TMUX_SESSION_NAME} as session name"
    else
	echo "Not using session name"
    fi
}


# Dev
function df_tmux_new_session_dev() {
    export TMUX_SESSION_NAME='dev'
    # 'editor' window
    tmux new-session -d -s ${TMUX_SESSION_NAME} -n editor
    tmux send-keys -t ${TMUX_SESSION_NAME}:editor "cd ~/Workspace/"  C-m
    tmux send-keys -t ${TMUX_SESSION_NAME}:editor "emacs -nw"  C-m

    # 'code' window
    tmux new-window -t ${TMUX_SESSION_NAME} -n code
    tmux send-keys -t ${TMUX_SESSION_NAME}:code "cd ~/Code/github.com/asajaroff/" C-m

    # 'shell' window
    tmux new-window -t ${TMUX_SESSION_NAME} -n shell
    tmux split-window -d 
    tmux send-keys -t ${TMUX_SESSION_NAME}:shell "fastfetch" C-m

    tmux a -t ${TMUX_SESSION_NAME} 
}

# Work
function df_tmux_new_session_work() {
    export TMUX_SESSION_NAME='work'
    # 'editor' window
    tmux new-session -d -s ${TMUX_SESSION_NAME} -n editor
    tmux send-keys -t ${TMUX_SESSION_NAME}:editor "cd ~/Code/"  C-m
    tmux send-keys -t ${TMUX_SESSION_NAME}:editor "emacs -nw"  C-m

    # 'code' window
    tmux new-window -t ${TMUX_SESSION_NAME} -n code
    tmux send-keys -t ${TMUX_SESSION_NAME}:code "cd ~/Code/github.com/EENCloud" C-m

    # 'shell' window
    tmux new-window -t ${TMUX_SESSION_NAME} -n shell
    tmux send-keys -t ${TMUX_SESSION_NAME}:shell "fastfetch" C-m
    tmux send-keys -t ${TMUX_SESSION_NAME}:shell "fastfetch" C-m

    tmux a -t ${TMUX_SESSION_NAME} 
}