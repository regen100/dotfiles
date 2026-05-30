if [[ -n $SSH_CONNECTION ]]; then
  export BROWSER=$HOME/bin/open-local
elif (( $+commands[socat] )) && ! pgrep -f 'TCP-LISTEN:17799' >/dev/null 2>&1; then
  setsid -f socat TCP-LISTEN:17799,reuseaddr,fork,bind=127.0.0.1 EXEC:open-recv >/dev/null 2>&1
fi
