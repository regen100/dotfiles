if [ "$TERM" = "linux" ] || [ "$LANG" = "C" ] || [ "$LANG" = "C.UTF-8" ] || [ -z "$LANG" ]; then
  export LANG=en_US.UTF-8
fi

export LESS="-giMRSW -z-4 -x4 -j4"

if type vim >/dev/null 2>&1; then
  export EDITOR=vim
  export VISUAL=vim
fi

if [ -e $HOME/.cargo/env ]; then
  . $HOME/.cargo/env
fi
if [ -d $HOME/.local/bin ]; then
  PATH="$HOME/.local/bin:$PATH"
fi
if [ -d $HOME/bin ]; then
  PATH="$HOME/bin:$PATH"
fi
export PATH

if [ -f /proc/sys/fs/binfmt_misc/WSLInterop ]; then
  export DISPLAY="$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}'):0"
fi
