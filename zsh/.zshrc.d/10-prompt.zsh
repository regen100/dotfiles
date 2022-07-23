if [[ $TERM != linux ]]; then
  if (( $+commands[starship] )); then
    prompt off && source <(starship init zsh)
  elif (( $+functions[prompt_pure_setup] )); then
    prompt pure
  fi
fi
