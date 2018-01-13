zstyle ':completion:*' use-cache true
zstyle ':completion:*:default' menu select=2

zstyle ':completion:*' ignore-parents parent pwd ..
zstyle ':completion:*:*files' ignored-patterns '*?.o' '*?~' '*\#'

zstyle ':completion:*' verbose yes
zstyle ':completion:*' completer _expand _complete _match _prefix _approximate _list _history
zstyle ':completion:*' group-name ''
zstyle ':completion:*' show-completer true
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:manuals' separate-sections true
zstyle ':completion:*:messages' format '%F{green}%d%f'
zstyle ':completion:*:warnings' format '%F{red}No matches for:%f %F{yellow}%d%f'
zstyle ':completion:*:descriptions' format '%F{green}%U%B%d%b%u%f'

if [ -f /usr/share/bash-completion/completions/lxc ]; then
  autoload bashcompinit
  bashcompinit
  export -f _have() { which $@ >/dev/null }
  source /usr/share/bash-completion/completions/lxc
fi
