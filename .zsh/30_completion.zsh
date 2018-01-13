zstyle ':completion:*' use-cache true
zstyle ':completion:*:default' menu select=2

if [ -f /usr/share/bash-completion/completions/lxc ]; then
  autoload bashcompinit
  bashcompinit
  export -f _have() { which $@ >/dev/null }
  source /usr/share/bash-completion/completions/lxc
fi
