autoload -Uz add-zsh-hook

ls_abbrev() {
  if [[ $ZSH_SUBSHELL -eq 1 ]]; then return; fi
  local -r ls_result=$(COLUMNS=$COLUMNS command ls -aCF --color=always)
  local -r ls_lines=$(echo "$ls_result" | wc -l)
  if [[ $ls_lines -gt 10 ]]; then
    echo "$ls_result" | head -n 5
    echo ...
    echo "$ls_result" | tail -n 5
    echo "$(command ls -1 -A | wc -l) files exist"
  else
    echo "$ls_result"
  fi
}
add-zsh-hook chpwd ls_abbrev

reset_prompt() {
  echo -ne '\e[5 q'     # reset cursor (DECSCUSR)
  echo -ne '\e[?1000l'  # mouse tracking off (man console_codes)
}
add-zsh-hook precmd reset_prompt

reset_env() {
  [[ -n $TMUX ]] && eval "$(tmux show-environment -s | grep -v '^unset .*SSH_AUTH_SOCK')"
}
add-zsh-hook preexec reset_env
