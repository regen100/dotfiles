if [[ $TERM == "linux" ]]; then
  export LANG=en_US.UTF-8
fi
if [[ -n $FBTERM ]]; then
  export TERM=fbterm
fi

setopt auto_cd
setopt auto_pushd
setopt pushd_ignore_dups

setopt always_to_end
setopt complete_in_word
unsetopt list_beep
WORDCHARS=''

[[ -f $HOME/.dircolors ]] || wget -qO $HOME/.dircolors https://github.com/dotphiles/dotzsh/raw/master/themes/dotphiles/dircolors/dircolors.base16.dark
if (( $+commands[dircolors] )); then
  eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi
if [[ -z $LS_COLORS ]]; then
  zstyle ':completion:*' list-colors 'di=34:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43:'
else
  zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
fi

setopt hist_expire_dups_first
setopt hist_find_no_dups
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_verify
setopt inc_append_history

[[ -z $HISTFILE ]] && HISTFILE=$HOME/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

unsetopt flow_control

setopt interactivecomments
