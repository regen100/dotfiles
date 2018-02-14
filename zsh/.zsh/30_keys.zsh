bindkey -e

bindkey '^P' history-beginning-search-backward
bindkey '^N' history-beginning-search-forward

[ -n "${terminfo[kcbt]}" ] && bindkey "${terminfo[kcbt]}" reverse-menu-complete
[ -n "${terminfo[khome]}" ] && bindkey "${terminfo[khome]}" beginning-of-line
[ -n "${terminfo[kend]}" ] && bindkey "${terminfo[kend]}" end-of-line
[ -n "${terminfo[kbs]}" ] && bindkey "${terminfo[kbs]}" backward-delete-char
[ -n "${terminfo[kdch1]}" ] && bindkey "${terminfo[kdch1]}" delete-char
[ -n "${terminfo[kcuu1]}" ] && bindkey "${terminfo[kcuu1]}" up-line-or-history
[ -n "${terminfo[kcud1]}" ] && bindkey "${terminfo[kcud1]}" down-line-or-history
[ -n "${terminfo[kcub1]}" ] && bindkey "${terminfo[kcub1]}" backward-char
[ -n "${terminfo[kcuf1]}" ] && bindkey "${terminfo[kcuf1]}" forward-char
