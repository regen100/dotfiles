zstyle ':completion:*' use-cache true
zstyle ':completion:*:default' menu select=2
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Z}{a-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

zstyle ':completion:*' ignore-parents parent pwd ..
zstyle ':completion:*:*files' ignored-patterns '*?.o' '*?~' '*\#'

zstyle ':completion:*' verbose yes
zstyle ':completion:*' completer _expand _complete _match _prefix _approximate _list _history
zstyle ':completion:*' group-name ''
zstyle ':completion:*' show-completer true
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:manuals' separate-sections true
zstyle ':completion:*:messages' format '%F{green}%d%f'
zstyle ':completion:*:warnings' format '%F{red}No matches for:%f %F{green}%d%f'
zstyle ':completion:*:descriptions' format '%U%F{green}%d%f%u'
zstyle ':completion:*:corrections' format '%U%F{green}%d%f%u %F{red}(errors:%e)%f'

# autoload -U bashcompinit && bashcompinit
# export -f _have() { which "$@" >/dev/null }

if (( $+commands[rustc] )); then
  fpath+=$(rustc --print sysroot)/share/zsh/site-functions
fi

fpath=(~/.zsh/functions $fpath)
