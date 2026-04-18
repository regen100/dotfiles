autoload -Uz bashcompinit && bashcompinit

[[ -d ${ZDOTDIR:-~}/.antidote ]] || git clone --depth=1 https://github.com/mattmc3/antidote.git ${ZDOTDIR:-~}/.antidote
source ${ZDOTDIR:-~}/.antidote/antidote.zsh
antidote load

autoload -Uz manydots-magic 2>/dev/null && manydots-magic 2>/dev/null

(( $+commands[aws_completer] )) && complete -C aws_completer aws
(( $+commands[mise] )) && eval "$(mise activate zsh)"

[[ "$TERM_PROGRAM" == "vscode" ]] && . "$(code --locate-shell-integration-path zsh)"

ssh-add -l >/dev/null 2>&1
if (( $? == 2 )); then
  export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR:-$HOME/.ssh}/ssh-agent.sock"
  ssh-add -l >/dev/null 2>&1
  if (( $? == 2 )); then
    rm -f "$SSH_AUTH_SOCK"
    eval "$(ssh-agent -a "$SSH_AUTH_SOCK")" >/dev/null
  fi
fi
