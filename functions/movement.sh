func tmpfile() {
  FILENAME=`date "+%Y-%m-%d_%H:%M:%S"`
  if [ -z "$1" ]; then
    touch ~/Workspace/tmp/$1.md
    nvim ~/Workspace/tmp/$1.md
  else
    touch ~/Workspace/tmp/${FILENAME}.md
    nvim ${HOME}/Workspace/tmp/${FILENAME}.md
  fi
}
