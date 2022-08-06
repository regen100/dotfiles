if [[ -z "$DISPLAY" && -n "$WSL_HOST_IP" ]]; then
  export DISPLAY="${WSL_HOST_IP}:0"
  (( $(xauth list "$DISPLAY" 2>&1 | wc -l) )) || xauth generate "$DISPLAY"
fi
