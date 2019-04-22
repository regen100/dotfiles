mkdir  -p ~/.zplugin
[[ -d ~/.zplugin/bin ]] || git clone https://github.com/zdharma/zplugin.git ~/.zplugin/bin
source ~/.zplugin/bin/zplugin.zsh

PATCH_DIR=$(dirname $0)/patches

zplugin light zsh-users/zsh-completions
zplugin ice atload'COMMAND_NOT_FOUND_INSTALL_PROMPT=1'; zplugin snippet PZT::modules/command-not-found/init.zsh
zplugin ice as'completion' if'(( $+commands[docker-compose] ))'; zplugin snippet https://github.com/docker/compose/raw/master/contrib/completion/zsh/_docker-compose
zplugin ice if'(( $+commands[rustc] ))'; zplugin light rust-lang/zsh-config
zplugin light caarlos0/zsh-mkc
zplugin snippet https://github.com/tj/git-extras/raw/master/etc/git-extras-completion.zsh
zplugin ice as'program' atclone"git apply $PATCH_DIR/git-foresta.patch" atpull'%atclone'; zplugin light takaaki-kasai/git-foresta
zplugin snippet OMZ::plugins/colored-man-pages/colored-man-pages.plugin.zsh
zplugin snippet OMZ::plugins/sudo/sudo.plugin.zsh
zplugin snippet OMZ::plugins/kubectl/kubectl.plugin.zsh
zplugin ice pick'async.zsh' src'pure.zsh' if'[[ $TERM != linux ]]'; zplugin light sindresorhus/pure
zplugin ice lucid wait'0' multisrc'{completion,key-bindings}.zsh'; zplugin light /usr/share/fzf
zplugin ice lucid wait'0'; zplugin snippet OMZ::plugins/git/git.plugin.zsh
zplugin ice lucid wait'0' atload'[[ -r ~/.base16_theme ]] || base16_default-dark'; zplugin light chriskempson/base16-shell
zplugin ice lucid wait'0' atload'ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=default-enter; _zsh_autosuggest_start' if'[[ $TERM != linux ]]'; zplugin light zsh-users/zsh-autosuggestions
zplugin ice lucid wait'0' atinit'zpcompinit; zpcdreplay'; zplugin light zdharma/fast-syntax-highlighting

zstyle -g existing_user_commands ':completion:*:*:git:*' user-commands
zstyle ':completion:*:*:git:*' user-commands $existing_user_commands foresta:'show commit graph'
_git-foresta() _git-log

if (( $+commands[ag] )); then
  export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND"
fi

(( $+commands[lesspipe] )) && eval "$(lesspipe)"
(( $+commands[lesspipe.sh] )) && eval "$(lesspipe.sh)"

# clean
unset PATCH_DIR
rm -rf ~/.zplug ~/.zplug_installed
