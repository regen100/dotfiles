if ! (( $+commands[wslpath] )); then
  return
fi

if [[ ! -f ~/bin/start ]]; then
  mkdir -p ~/bin
  install -m 755 <(echo '#!/bin/bash'; echo 'powershell.exe /C start \""$1"\"') ~/bin/start
fi
export BROWSER=$HOME/bin/start

hash -d desktop="$(wslpath "$(/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe /C Write-Output '${Env:USERPROFILE}' | sed 's/\r//')")/Desktop"
