if [[ -n $WSL_HOST_IP && -n $DISPLAY && $+commands[xauth] == 1 ]]; then
  (( $(xauth list "$DISPLAY" 2>&1 | wc -l) )) || xauth generate "$DISPLAY"
fi
