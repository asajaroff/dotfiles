#!/usr/bin/env bash
function claude-worktree {
	local name="${1:?usage: claude-worktree <name>}"
	claude --tmux --worktree "$name" --name "$name" --agent sre-readonly
}
