[[ -e ~/.profile ]] && source ~/.profile

if [[ -n $SSH_TTY && -z $TMUX && $+commands[tmux] -eq 1 ]]; then
  (tmux attach || tmux) >/dev/null 2>&1
  exit
fi
