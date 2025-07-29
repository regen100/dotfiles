#!/bin/sh

export LESS="-giMRSW -z-4 -x4 -j4"

if type vim >/dev/null 2>&1; then
  export EDITOR=vim
  export VISUAL=vim
fi

if type google-chrome-stable >/dev/null 2>&1; then
  export CHROME_EXECUTABLE=google-chrome-stable
fi

if [ -e /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -e /home/linuxbrew/.linuxbrew/bin/brew ]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
elif [ -e "$HOME/.linuxbrew/bin/brew" ]; then
  eval "$("$HOME/linuxbrew/.linuxbrew/bin/brew" shellenv)"
fi

export GEM_HOME="$HOME/.gem"
export NPM_CONFIG_PREFIX="$HOME/.local"

if [ -d /opt/homebrew/opt/coreutils/libexec/gnubin ]; then
  PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"
fi
if [ -e /usr/lib/emscripten/emcc ]; then
  PATH="/usr/lib/emscripten:$PATH"
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
if [ -d "$HOME/.pub-cache/bin" ]; then
  PATH="$HOME/.pub-cache/bin:$PATH"
fi
if [ -d "$GEM_HOME/bin" ]; then
  PATH="$GEM_HOME/bin:$PATH"
fi
export PATH

export CLOUDSDK_PYTHON=python
