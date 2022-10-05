if [[ -z $WSL_HOST_IP ]]; then
  return
fi

if [[ -z $DISPLAY ]]; then
  export DISPLAY="${WSL_HOST_IP}:0"
  (( $(xauth list "$DISPLAY" 2>&1 | wc -l) )) || xauth generate "$DISPLAY"
fi

if [[ ! -f ~/bin/start ]]; then
  mkdir -p ~/bin
  install -m 755 <(echo '#!/bin/bash'; echo 'powershell.exe /C start \""$1"\"') ~/bin/start
fi
export BROWSER=$HOME/bin/start
