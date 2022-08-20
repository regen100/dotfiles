if [[ -z $WSL_HOST_IP ]]; then
  return
fi

if [[ -z $DISPLAY ]]; then
  export DISPLAY="${WSL_HOST_IP}:0"
  (( $(xauth list "$DISPLAY" 2>&1 | wc -l) )) || xauth generate "$DISPLAY"
fi

export BROWSER="powershell.exe /C start"
