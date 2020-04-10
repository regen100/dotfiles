autoload -Uz add-zsh-hook

# direnv
(( $+commands[direnv] )) && eval "$(direnv hook zsh)"

# display switch
if [[ -n $BYOBU_TTY ]]; then
  add-zsh-hook preexec update_vars
  update_vars() {
    [[ "SSH_CONNECTION=$SSH_CONNECTION" != $(tmux show-env SSH_CONNECTION) && -f ~/.base16_theme ]] && source ~/.base16_theme
    source /usr/bin/byobu-reconnect-sockets
  }
fi

# cdls
add-zsh-hook chpwd ls_abbrev
