# profiling
[[ -n $ZPROF ]] && zmodload zsh/zprof && zprof

# path
if [[ -z $ZSHENV_LOADED ]]; then
  path=($HOME/bin(N-/) $HOME/dotfiles/bin(N-/) /opt/VirtualGL/bin(N-/) /snap/bin(N-/) $path)
  path=(./node_modules/.bin $path)

  llvm_dirs=(/usr/lib/llvm-*(N-/))
  if [[ -n $llvm_dirs ]]; then
    export LLVM_DIR=$(ls -td $llvm_dirs | head -1)
    path=($LLVM_DIR/bin(N-/) $path)
  fi

  export LESS='-giMRSW -z-4 -x4 -j4'
  export EDITOR=vim
  export VISUAL=vim
  eval "$(lesspipe)"

  [[ -f $HOME/.cargo/env ]] && source $HOME/.cargo/env

  export CCACHE_SLOPPINESS=pch_defines,time_macros

  export ZSHENV_LOADED=1
fi
