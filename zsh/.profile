#!/bin/sh

export LESS="-giMRSW -z-4 -x4 -j4"

if type vim >/dev/null 2>&1; then
  export EDITOR=vim
  export VISUAL=vim
fi

if [ -e /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi
if type python3 >/dev/null 2>&1; then
  PATH="$(python3 -m site --user-site)/../../../bin:$PATH"
fi
if [ -d /opt/homebrew/opt/coreutils/libexec/gnubin ]; then
  PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"
fi
if [ -d "$HOME/.local/bin" ]; then
  PATH="$HOME/.local/bin:$PATH"
fi
if [ -d "$HOME/bin" ]; then
  PATH="$HOME/bin:$PATH"
fi
if [ -d "$HOME/go/bin" ]; then
  PATH="$HOME/go/bin:$PATH"
fi
if [ -d "$HOME/.cargo/bin" ]; then
  PATH="$HOME/.cargo/bin:$PATH"
fi
export PATH

export CLOUDSDK_PYTHON=python
