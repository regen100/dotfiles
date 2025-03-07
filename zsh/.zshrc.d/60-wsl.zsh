if ! (( $+commands[wslpath] )); then
  return
fi

readonly powershell="/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe"

if [[ ! -f ~/bin/start ]]; then
  mkdir -p ~/bin
  install -m 755 <(echo '#!/bin/bash'; echo "$powershell"' /C start \""$1"\"') ~/bin/start
fi
export BROWSER=$HOME/bin/start

hash -d desktop="$(wslpath "$($powershell /C Write-Output '${Env:USERPROFILE}' | sed 's/\r//')")/Desktop"

if [[ ! -e /tmp/.X11-unix/X0 ]]; then
  ln -sf /mnt/wslg/.X11-unix/X0 /tmp/.X11-unix/
fi
