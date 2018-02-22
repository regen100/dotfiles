wttr() {
  curl -H "Accept-Language: ${LANG%_*}" "wttr.in/${1}"
}

lxce() {
  lxc exec "$1" -- sudo --login --user ubuntu
}

get_tty() {
  local tty
  if [[ -n $TMUX ]]; then
    tty=$(tmux run-shell 'echo #{client_tty}')
  else
    tty=$(tty)
  fi
  tty=${tty#/dev/}
  echo ${tty//\//}
}

ls_abbrev() {
  # see: https://qiita.com/yuyuchu3333/items/b10542db482c3ac8b059
  if [[ ! -r $PWD ]]; then
    return
  fi
  # -a : Do not ignore entries starting with ..
  # -C : Force multi-column output.
  # -F : Append indicator (one of */=>@|) to entries.
  local cmd_ls='ls'
  local -a opt_ls
  opt_ls=('-aCF' '--color=always')
  case "${OSTYPE}" in
    freebsd*|darwin*)
      if type gls > /dev/null 2>&1; then
        cmd_ls='gls'
      else
        # -G : Enable colorized output.
        opt_ls=('-aCFG')
      fi
      ;;
  esac

  local ls_result
  ls_result=$(CLICOLOR_FORCE=1 COLUMNS=$COLUMNS command $cmd_ls ${opt_ls[@]} | sed $'/^\e\[[0-9;]*m$/d')

  local ls_lines=$(echo "$ls_result" | wc -l | tr -d ' ')

  if [ $ls_lines -gt 10 ]; then
    echo "$ls_result" | head -n 5
    echo '...'
    echo "$ls_result" | tail -n 5
    echo "$(command ls -1 -A | wc -l | tr -d ' ') files exist"
  else
    echo "$ls_result"
  fi
}
