# path
if [[ -z $ZSHENV_LOADED ]]; then
  path=($HOME/bin(N-/) $HOME/dotfiles/bin(N-/) /opt/VirtualGL/bin(N-/) ./node_modules/.bin $path)

  llvm_dirs=(/usr/lib/llvm-*(N-/))
  if [[ -n $llvm_dirs ]]; then
    export LLVM_DIR=$(ls -td $llvm_dirs | head -1)
    path=($LLVM_DIR/bin(N-/) $path)
  fi

  [[ -f $HOME/.cargo/env ]] && source $HOME/.cargo/env

  export ZSHENV_LOADED=1
fi
