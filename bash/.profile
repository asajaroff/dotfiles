# shellcheck shell=bash
if [ -n "$BASH_VERSION" ] && [ -n "$PS1" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
    fi
fi

export GITHUB_MCP_PAT="REDACTED"
