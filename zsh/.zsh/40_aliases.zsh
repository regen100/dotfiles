alias ls='ls --color=auto'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

(( $+commands[python3] )) && alias python=python3
(( $+commands[pygmentize] )) && alias pygmentize='pygmentize -f 256 -O style=base16-${BASE16_THEME#base16-}'

if (( $+commands[rlwrap] )); then
  alias rlwrap='rlwrap -pyellow'
  for cmd (nc jjs)
    (( $+commands[$cmd] )) && alias $cmd="rlwrap $cmd"
fi

alias -s txt=cat
(( $+commands[python] )) && alias -s py=python
(( $+commands[ruby] )) && alias -s rb=ruby
(( $+commands[aunpack] )) && alias -s {gz,tgz,zip,lzh,bz2,tbz,Z,tar,arj,xz}=aunpack

alias relogin='unset ZSHENV_LOADED; exec $SHELL -l'

(( $+commands[xclip] )) && alias xclip='xclip -sel clip'

alias mmv='noglob zmv -W'
alias gdbrun='gdb -ex="set confirm on" -ex=run -ex=quit --args'
alias valgrindrun='valgrind --exit-on-first-error=yes --error-exitcode=1'

CMAKE_CXX_FLAGS="-fstandalone-debug -fcolor-diagnostics -march=native -ferror-limit=1"
CMAKE_COMMON_OPTIONS=(-DBUILD_SHARED_LIBS=ON -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -DCMAKE_INSTALL_PREFIX=install)
CMAKE_CCACHE=(-DCMAKE_CXX_COMPILER_LAUNCHER=ccache -DCMAKE_C_COMPILER_LAUNCHER=ccache)
alias -g CMAKE_DEV='"$CMAKE_CCACHE[@]" -DCMAKE_CXX_COMPILER=clang++ -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_FLAGS="$CMAKE_CXX_FLAGS" -DCMAKE_C_FLAGS="$CMAKE_CXX_FLAGS" "$CMAKE_COMMON_OPTIONS[@]"'
alias -g CMAKE_DEV_ZAPCC='-DCMAKE_CXX_COMPILER=zapcc++ -DCMAKE_C_COMPILER=zapcc -DCMAKE_CXX_FLAGS="$CMAKE_CXX_FLAGS -isystem/usr/lib/zapcc/7.0.0/include" -DCMAKE_C_FLAGS="$CMAKE_CXX_FLAGS -isystem/usr/lib/zapcc/7.0.0/include" "$CMAKE_COMMON_OPTIONS[@]"'

(( $+commands[ag] )) && alias todo='ag "//\s*(TODO|FIXME)\b"'

alias docker-user="docker -H unix://$XDG_RUNTIME_DIR/docker.sock"
