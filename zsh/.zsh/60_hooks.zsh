autoload -Uz add-zsh-hook

# direnv
(( $+commands[direnv] )) && eval "$(direnv hook zsh)"

# display switch
if [[ -n $BYOBU_TTY ]]; then
  add-zsh-hook preexec update_vars
  update_vars() {
    local PRE_DISPLAY=$DISPLAY
    source /usr/bin/byobu-reconnect-sockets
    [[ $PRE_DISPLAY != $DISPLAY && -f ~/.base16_theme ]] && source ~/.base16_theme
  }
fi

# cdls
add-zsh-hook chpwd ls_abbrev
