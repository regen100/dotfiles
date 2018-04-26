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

alias -g CMAKE_DEV='-DCMAKE_CXX_COMPILER=clang++ -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_FLAGS="-fcolor-diagnostics -march=native" -DCMAKE_EXE_LINKER_FLAGS=-fuse-ld=gold -DCMAKE_SHARED_LINKER_FLAGS=-fuse-ld=gold -DBUILD_SHARED_LIBS=ON -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -DCMAKE_INSTALL_PREFIX=install'

(( $+commands[ag] )) && alias todo='ag "//\s*(TODO|FIXME)\b"'
