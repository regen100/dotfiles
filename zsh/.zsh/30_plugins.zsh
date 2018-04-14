if [[ ! -d ~/.zplug ]]; then
  git clone https://github.com/zplug/zplug ~/.zplug
fi
source ~/.zplug/init.zsh

zstyle ":zplug:tag" depth 1

zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-autosuggestions", hook-load:"ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=default-enter"
zplug "chriskempson/base16-shell", hook-load:"[[ -L ~/.base16_theme ]] || base16_default-dark"
zplug "junegunn/fzf", use:"shell/*.zsh", hook-build:"./install --bin", hook-load:"path=($ZPLUG_ROOT/repos/junegunn/fzf/bin $path)"
zplug "b4b4r07/enhancd", use:init.sh
zplug "modules/command-not-found", from:prezto
zplug "mollifier/cd-bookmark", hook-load:"alias cdb=cd-bookmark"
zplug "docker/compose", use:contrib/completion/zsh, if:"(( $+commands[docker-compose] ))"
zplug "rust-lang/zsh-config", if:"(( $+commands[rustc] ))"
zplug "lukechilds/zsh-better-npm-completion", if:"(( $+commands[npm] ))"
zplug "caarlos0/zsh-mkc"
zplug "marzocchi/zsh-notify", if:"[[ -n $DISPLAY ]] && xdotool getactivewindow >/dev/null 2>&1"
zplug 'endaaman/lxd-completion-zsh', if:"(( $+commands[lxc] ))"
zplug "tj/git-extras", at:"4.5.0", use:"etc/git-extras-completion.zsh", hook-build:"make install PREFIX=$HOME/.local"

zplug "plugins/colored-man-pages", from:oh-my-zsh
zplug "plugins/common-aliases", from:oh-my-zsh
zplug "plugins/python", from:oh-my-zsh
zplug "plugins/pip", from:oh-my-zsh
zplug "plugins/sudo", from:oh-my-zsh

if [[ $TERM != "linux" && -z $MYVIMRC ]]; then
  zplug "bhilburn/powerlevel9k", use:powerlevel9k.zsh-theme, as:theme
else
  zplug "mafredri/zsh-async"
  zplug "sindresorhus/pure", use:pure.zsh, as:theme
fi

installed=$HOME/.zplug_installed
if [[ ! -f $installed || $0 -nt $installed ]]; then
  if ! zplug check; then
    zplug install && touch $installed
  fi
fi

POWERLEVEL9K_MODE='nerdfont-complete'
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(detect_virt ssh context dir_writable nodeenv virtualenv anaconda rbenv)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status command_execution_time background_jobs vcs dir time)
POWERLEVEL9K_SHORTEN_DIR_LENGTH=3
POWERLEVEL9K_SHORTEN_STRATEGY=truncate_from_right

zplug load

typeset -x MANPATH
manpath=($ZPLUG_ROOT/doc/man(N-/) $ZPLUG_ROOT/repos/junegunn/fzf/man(N-/) $ZPLUG_ROOT/repos/tj/git-extras/man(N-/) $HOME/.local/share/man(N-/) "")

# FZF
if (( $+commands[ag] )); then
  export FZF_DEFAULT_COMMAND='ag --nocolor -g ""'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND"
fi
