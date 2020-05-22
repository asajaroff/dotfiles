function repo-template {
    if [ -z "$1" ]
    then
        echo "Usage: `basename $0` repo_name"
        exit 1
    fi

    mkdir $1
    cp $HOME/.dotfiles/functions/resources/template_CHANGELOG $1/CHANGELOG
    cp $HOME/.dotfiles/functions/resources/template_Makefile $1/Makefile
    sed "s/Project Title/$1/g" $HOME/.dotfiles/functions/resources/template_README.md > $1/README.md
}