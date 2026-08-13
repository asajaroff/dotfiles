#!/usr/bin/env bash

function bare-clone () {
    local repo_url="${1:?usage: bare-clone <repo-url>}"
    local repo_name
    repo_name=$(basename "$repo_url")
    repo_name="${repo_name%/.git}"
    repo_name="${repo_name%.git}"
    if [ -z "$repo_name" ] || [ "$repo_name" = ".git" ]; then
        echo "bare-clone: could not determine repo name from '$repo_url'" >&2
        return 1
    fi

    git clone --bare "$repo_url" "$repo_name/.bare" || return 1

    local default_branch
    default_branch=$(
        cd "$repo_name/.bare" || exit 1
        git config remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*' || exit 1
        git fetch origin || exit 1

        local db
        db=$(git symbolic-ref --short HEAD) || exit 1

        git worktree add "../$db" "$db" || exit 1
        git -C "../$db" branch --set-upstream-to="origin/$db" "$db" || {
            echo "bare-clone: failed to set upstream tracking branch" >&2
            exit 1
        }
        echo "$db"
    )

    if [ $? -ne 0 ] || [ -z "$default_branch" ]; then
        rm -rf "$repo_name"
        return 1
    fi

    echo "Worktree ready at: $repo_name/$default_branch"
}
