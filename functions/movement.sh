func repos () {
	if [ -z "$1" ]; then
		if  [ "${PWD}" = "${REPOS}" ]; then
			echo "Already at repos folder"
		else
			cd $REPOS
			ls -1
		fi
	else
		DIR=${1}
		cd "${REPOS}/${DIR}"
		ls -1
	fi
}

func tmp() {
  if [ -z "$1" ]; then
    mkdir -p ~/Workspace/tmp/$1
    cd ~/Workspace/tmp/$1
  else
    cd ~/Workspace/tmp
  fi
}
