#!/usr/bin/env bash

function package-search() {
	pacman --query --search "$@" --color=always
    }