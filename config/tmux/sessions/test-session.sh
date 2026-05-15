#!/bin/sh

set -ex
SESSION_NAME='sample'

tmux new-session -s ${SESSION_NAME}

tmux new-window -t ${SESSION_NAME}:9 \
	-n editor 'cd ~/Code; emacs -nw'
tmux new-session -s ${SAMPLE} \
	-n work -d 'cd ~/Code/EENCloud; bash -i' \
tmux new-window -t ${SESSION_NAME}:1 \
	-n tmp 'cd /tmp/`date`; bash -i'
tmux new-window -t ${SESSION_NAME}:2 \
	-n log 'cd /var/log; bash -i'

tmux select-window -t e:1
tmux -2 attach-session -t e

set +ex
