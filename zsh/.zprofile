[[ -e ~/.profile ]] && source ~/.profile

if [[ $- = *i* && $- = *l* && $+commands[tmux] -eq 1 && -z $TMUX ]]; then
  (tmux attach || tmux) >/dev/null 2>&1
  exit
fi
