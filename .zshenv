# path
if [ -z $ZSHENV_LOADED ]; then
  path=($HOME/bin(N-/) $HOME/dotfiles/bin(N-/) /usr/lib/llvm-5.0/bin(N-/) /opt/VirtualGL/bin(N-/) ./node_modules/.bin $path)
  [ -f $HOME/.cargo/env ] && source $HOME/.cargo/env
  export ZSHENV_LOADED=1
fi
