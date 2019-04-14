# path
if [[ -z $ZSHENV_LOADED ]]; then
  export LANG=en_US.UTF-8

  path=($HOME/bin(N-/) $HOME/.local/bin(N-/) $HOME/.linuxbrew/bin(N-/) $HOME/.linuxbrew/sbin(N-/) /opt/VirtualGL/bin(N-/) /snap/bin(N-/) /usr/local/cuda/bin(N-/) $path)
  path=(./node_modules/.bin $path)

  export LESS='-giMRSW -z-4 -x4 -j4'
  export EDITOR=vim
  export VISUAL=vim

  [[ -f $HOME/.pythonrc.py ]] && export PYTHONSTARTUP=$HOME/.pythonrc.py

  [[ -f $HOME/.cargo/env ]] && source $HOME/.cargo/env

  export NVIM_LISTEN_ADDRESS=/tmp/nvimsocket

  export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=gasp'

  export ZSHENV_LOADED=1
fi
