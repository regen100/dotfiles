#shellcheck disable=SC1090,SC2154

[[ -e ~/.profile ]] && source ~/.profile

ssh-add -l >/dev/null 2>&1
if [[ $? = 2 ]]; then
  for line in $(find /tmp -uid $(id -u) -type s -name "agent.*" 2>/dev/null); do
    SSH_AUTH_SOCK="$line" ssh-add -l >/dev/null 2>&1
    if [[ $? != 2 ]]; then
      export SSH_AUTH_SOCK="$line"
      break
    fi
  done
  if [[ -z $SSH_AUTH_SOCK ]]; then
    eval "$(ssh-agent)"
  fi
fi

if [[ -n $SSH_TTY && -z $TMUX && $(($+commands[tmux])) -eq 1 ]]; then
  (tmux attach || tmux) >/dev/null 2>&1
  exit
fi
