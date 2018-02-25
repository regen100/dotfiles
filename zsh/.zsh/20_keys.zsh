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

default-enter() {
  if [[ -z $BUFFER ]]; then
    case $[ENTER_COUNT++] in
      0)
        BUFFER=" ls_abbrev"
        ;;
      1)
        if git rev-parse 2>/dev/null; then
          BUFFER=" git status --short --branch"
        fi
        ;;
      2)
        if git rev-parse 2>/dev/null; then
          BUFFER=" git --no-pager log --graph --decorate --oneline -n 5"
        fi
        ;;
    esac
  else
    ENTER_COUNT=0
  fi
  [[ -n $BUFFER ]] && zle .accept-line
}
zle -N default-enter
bindkey ^m default-enter
