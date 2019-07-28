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