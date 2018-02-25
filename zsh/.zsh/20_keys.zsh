bindkey -e

bindkey '^P' history-beginning-search-backward
bindkey '^N' history-beginning-search-forward
bindkey '^[[Z' reverse-menu-complete

rationalise-dot() {
  if [[ $LBUFFER = *.. ]]; then
    LBUFFER+=/..
  else
    LBUFFER+=.
  fi
}
zle -N rationalise-dot
bindkey . rationalise-dot

is-in-git() git rev-parse 2>/dev/null
default-enter() {
  if [[ -n $BUFFER ]]; then
    ENTER_COUNT=0
    zle .accept-line
    return
  fi

  local cmd
  while [[ -z $cmd ]]; do
    case $[ENTER_COUNT++] in
      0) cmd="ls_abbrev" ;;
      1) is-in-git && cmd="git status --short --branch" ;;
      2) is-in-git && cmd="git --no-pager log --graph --decorate --oneline -n 5" ;;
      *) return 1 ;;
    esac
  done
  echo && eval $cmd
  zle reset-prompt
}
zle -N default-enter
bindkey ^m default-enter

autoload -Uz smart-insert-last-word
zle -N insert-last-word smart-insert-last-word
