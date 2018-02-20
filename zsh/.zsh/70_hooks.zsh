autoload -Uz add-zsh-hook

(( $+commands[direnv] )) && eval "$(direnv hook zsh)"

[[ -z $TMUX && -n $DISPLAY ]] && echo $DISPLAY > ~/.display
function update_display() {
  [[ -f ~/.display ]] && export DISPLAY="$(cat ~/.display)"
}
add-zsh-hook preexec update_display
