autoload -Uz bashcompinit && bashcompinit

[[ -d ${ZDOTDIR:-~}/.antidote ]] || git clone --depth=1 https://github.com/mattmc3/antidote.git ${ZDOTDIR:-~}/.antidote
source ${ZDOTDIR:-~}/.antidote/antidote.zsh
antidote load

autoload -Uz manydots-magic 2>/dev/null && manydots-magic 2>/dev/null

(( $+commands[aws_completer] )) && complete -C aws_completer aws
(( $+commands[pdm] )) && eval "$(pdm --pep582)"

[[ "$TERM_PROGRAM" == "vscode" ]] && . "$(code --locate-shell-integration-path zsh)"

ssh-add -l >/dev/null 2>&1
if [[ $? = 2 ]]; then
  for line in $(find /tmp -uid $(id -u) -type s -name "agent.*" 2>/dev/null); do
    SSH_AUTH_SOCK="$line" ssh-add -l >/dev/null 2>&1
    if [[ $? != 2 ]]; then
      export SSH_AUTH_SOCK="$line"
      break
    fi
  done
  if [[ -z $SSH_AUTH_SOCK ]]; then
    eval "$(ssh-agent)"
  fi
fi
