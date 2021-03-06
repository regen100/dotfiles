#!/bin/sh

if [ "$TERM" = "linux" ] || [ "$LANG" = "C.UTF-8" ] || [ -z "$LANG" ]; then
  export LANG=en_US.UTF-8
fi

export LESS="-giMRSW -z-4 -x4 -j4"

if type vim >/dev/null 2>&1; then
  export EDITOR=vim
  export VISUAL=vim
fi

if [ -f $HOME/.cargo/env ]; then
  . $HOME/.cargo/env
fi

if [ -d $HOME/bin ]; then
  export PATH="$HOME/bin:$PATH"
fi
