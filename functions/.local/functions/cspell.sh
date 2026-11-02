#!/usr/bin/env bash
function cspell-add {
    local file=".cspell.json"
    [ -f "$file" ] || { echo "no $file in $PWD" >&2; return 1; }
    [ $# -gt 0 ] || { echo "usage: cspell-add <word> [word ...]" >&2; return 1; }
    local tmp
    tmp=$(mktemp) || return 1
    jq '.words = ((.words // []) + $ARGS.positional | unique)' --args "$@" < "$file" > "$tmp" \
        && mv "$tmp" "$file" \
        || { rm -f "$tmp"; return 1; }
}
