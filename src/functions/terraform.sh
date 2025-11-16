#!/usr/bin/env bash

function tf-module-template () {
    if [ -z "$1" ]; then
            read -r -p "Module name: " MODULE_NAME
    else
        MODULE_NAME=${1}
    fi
    if [ -d "$MODULE_NAME" ]; then
        echo "ERROR: Directory already exists."
        return 1
    else
        mkdir "$MODULE_NAME"
        touch "$MODULE_NAME"/{main,variables,outputs}.tf "$MODULE_NAME"/terraform.tfvars "$MODULE_NAME"/.gitignore "$MODULE_NAME"/README.md
        {
            echo "# Local .terraform directories"
            echo "**/.terraform/*"
            echo "# .tfstate files"
            echo "*.tfstate"
            echo "*.tfstate.*"
            echo "# Crash log files"
            echo "crash.log"
        } >> "$MODULE_NAME"/.gitignore
        echo "# ${MODULE_NAME}" > "$MODULE_NAME"/README.md
        cp "${DOTFILES_DIR}"/src/functions/resources/template_CHANGELOG "$MODULE_NAME"/CHANGELOG
        return 0
    fi
}

alias gotf="terraform init && terraform validate && terraform apply"