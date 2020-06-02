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

func tmpfile() {
  FILENAME=`date "+%Y-%m-%d_%H:%M:%S"`
  if [ -z "$1" ]; then
    touch ~/Workspace/tmp/$1.md
    code ~/Workspace/tmp/$1.md
  else
    touch ~/Workspace/tmp/${TMPDATE}.md
    code ${HOME}/Workspace/tmp/${FILENAME}.md
  fi
}
