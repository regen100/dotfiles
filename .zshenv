# path
if [ -z $ZSHENV_LOADED ]; then
  path=($HOME/bin(N-/) /usr/lib/llvm-5.0/bin(N-/) /opt/VirtualGL/bin(N-/) $path)
  [ -f $HOME/.cargo/env ] && source $HOME/.cargo/env
  export ZSHENV_LOADED=1
fi

[ -f /usr/local/lib/wcwidth-cjk.so ] && export LD_PRELOAD=/usr/local/lib/wcwidth-cjk.so
