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
