autoload -Uz add-zsh-hook

# direnv
(( $+commands[direnv] )) && eval "$(direnv hook zsh)"

# display switch
if [[ $(tty) = "not a tty" ]]; then
  add-zsh-hook preexec update_display
  update_display() {
    [[ -d ~/.display ]] || return 1
    local tty=$(ls -t ~/.display | head -1)
    [[ -n $tty ]] && export DISPLAY="$(cat ~/.display/$tty)"
  }
else
  [ -d ~/.display ] || mkdir ~/.display
  echo $DISPLAY > ~/.display/$(get_tty)
  add-zsh-hook preexec update_display
  update_display() {
    [[ -f ~/.display/$(get_tty) ]] && export DISPLAY="$(cat ~/.display/$(get_tty))"
  }
  add-zsh-hook zshexit clean_display
  clean_display() {
    [[ -z $TMUX ]] && rm -f ~/.display/$(get_tty)
  }
fi

# cdls
add-zsh-hook chpwd ls_abbrev
