[[ -e /etc/zsh_command_not_found ]] && source /etc/zsh_command_not_found
[[ -e /usr/share/doc/pkgfile/command-not-found.zsh ]] && source /usr/share/doc/pkgfile/command-not-found.zsh

[[ -e /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
[[ -e /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
[[ -e /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

[[ -e /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]] && source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
[[ -e /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]] && source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
[[ -e /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]] && source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

[[ -n $CLOUDSDK_ROOT_DIR ]] && source $CLOUDSDK_ROOT_DIR/completion.zsh.inc
(( $+commands[direnv] )) && source <(direnv hook zsh)
(( $+commands[keychain] )) && source <(keychain --eval --quiet --inherit any --agents ssh,gpg --ignore-missing --noask id_rsa id_ed25519)

autoload -Uz manydots-magic 2>/dev/null && manydots-magic 2>/dev/null

autoload -Uz bashcompinit && bashcompinit
(( $+commands[aws_completer] )) && complete -C aws_completer aws

(( $+commands[pdm] )) && eval "$(pdm --pep582)"
