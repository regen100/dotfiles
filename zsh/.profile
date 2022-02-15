#!/bin/sh

export LESS="-giMRSW -z-4 -x4 -j4"

if type vim >/dev/null 2>&1; then
  export EDITOR=vim
  export VISUAL=vim
fi

if [ -e "$HOME/.cargo/env" ]; then
  . "$HOME/.cargo/env"
fi
if [ -d "$HOME/.local/bin" ]; then
  PATH="$HOME/.local/bin:$PATH"
fi
if [ -d "$HOME/bin" ]; then
  PATH="$HOME/bin:$PATH"
fi
export PATH

if [ -e /proc/sys/fs/binfmt_misc/WSLInterop ]; then
  DISPLAY="$(</etc/resolv.conf awk '/nameserver/{print $2}'):0"
  export DISPLAY
fi
