bindkey -e

bindkey '^P' history-beginning-search-backward
bindkey '^N' history-beginning-search-forward

rationalise-dot() {
  if [[ $LBUFFER = *.. ]]; then
    LBUFFER+=/..
  else
    LBUFFER+=.
  fi
}
zle -N rationalise-dot
bindkey . rationalise-dot
