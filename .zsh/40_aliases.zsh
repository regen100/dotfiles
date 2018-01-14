alias ls='ls --color=auto'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

(( $+commands[python3] )) && alias python=python3

alias -s txt='cat'
(( $+commands[python] )) && alias -s py=python
(( $+commands[ruby] )) && alias -s rb=ruby
(( $+commands[aunpack] )) && alias -s {gz,tgz,zip,lzh,bz2,tbz,Z,tar,arj,xz}=aunpack

alias relogin='exec $SHELL -l'
