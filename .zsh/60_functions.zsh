wttr() {
  curl -H "Accept-Language: ${LANG%_*}" wttr.in/"${1}"
}

lxce() {
  lxc exec $1 -- sudo --login --user ubuntu
}
