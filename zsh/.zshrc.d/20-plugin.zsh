autoload -Uz bashcompinit && bashcompinit

[[ -d ${ZDOTDIR:-~}/.antidote ]] || git clone --depth=1 https://github.com/mattmc3/antidote.git ${ZDOTDIR:-~}/.antidote
source ${ZDOTDIR:-~}/.antidote/antidote.zsh
antidote load

autoload -Uz manydots-magic 2>/dev/null && manydots-magic 2>/dev/null

(( $+commands[keychain] )) && source <(keychain --eval --quiet --agents ssh --ignore-missing --noask id_ed25519)
(( $+commands[aws_completer] )) && complete -C aws_completer aws
(( $+commands[pdm] )) && eval "$(pdm --pep582)"
