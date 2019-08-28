function tf-module-teplate () {
    if [ -z "$1" ]; then
            read -p "Module name: " MODULE_NAME
    else
        MODULE_NAME=${1}
    fi
    if [ -d $MODULE_NAME ]; then
        echo "ERROR: Directory already exists."
        return 1
    else
        mkdir $MODULE_NAME
        touch $MODULE_NAME/{main,variables,outputs}.tf $MODULE_NAME/terraform.tfvars $MODULE_NAME/.gitignore $MODULE_NAME/README.md
        echo "# Local .terraform directories" > $MODULE_NAME/.gitignore
        echo "**/.terraform/*" >> $MODULE_NAME/.gitignore
        echo "# .tfstate files" >>$MODULE_NAME/.gitignore
        echo "*.tfstate" >> $MODULE_NAME/.gitignore
        echo "*.tfstate.*" >> $MODULE_NAME/.gitignore
        echo "# Crash log files" >> $MODULE_NAME/.gitignore
        echo "crash.log" >> $MODULE_NAME/.gitignore
        return 0
        echo "# ${MODULE_NAME}" > $MODULE_NAME/README.md
        cp $HOME/.dotfiles/functions/resources/temaplate_CHANGELOG $MODULE_NAME/CHANGELOG
    fi
}

alias gotf="terraform init && terraform validate && terraform apply"
