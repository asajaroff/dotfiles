function repo-template {
    if [ -z "$1" ]
    then
        echo "Usage: `basename $0` repo_name"
        exit 1
    fi

    mkdir $1
    echo "# $1" >> $1/README.md
    echo "## Description" >> $1/README.md

    echo "# Changelog" >> $1/CHANGELOG
    echo "All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]" >> $1/CHANGELOG

}