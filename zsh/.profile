#!/bin/sh

export LESS="-giMRSW -z-4 -x4 -j4"

ssh-add -l >/dev/null 2>&1
if [ $? -eq 2 ]; then
  ssh_sock_dir="${XDG_RUNTIME_DIR:-$HOME/.ssh}"
  export SSH_AUTH_SOCK="${ssh_sock_dir%/}/ssh-agent.sock"
  unset ssh_sock_dir
  ssh-add -l >/dev/null 2>&1
  if [ $? -eq 2 ]; then
    rm -f "$SSH_AUTH_SOCK"
    eval "$(ssh-agent -a "$SSH_AUTH_SOCK")" >/dev/null
  fi
fi

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
export PATH
