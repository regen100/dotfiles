# path
if [ -z $ZSHENV_LOADED ]; then
  path=($HOME/bin(N-/) /usr/lib/llvm-5.0/bin(N-/) $path)
  [ -f $HOME/.cargo/env ] && source $HOME/.cargo/env
  export ZSHENV_LOADED=1
fi
