wttr() {
  curl -H "Accept-Language: ${LANG%_*}" wttr.in/"${1}"
}
