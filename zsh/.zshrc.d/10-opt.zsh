export HISTFILESIZE=1000000000
export HISTSIZE=1000000000
setopt globdots
setopt hist_find_no_dups
setopt hist_ignore_all_dups
setopt hist_verify
setopt inc_append_history
setopt magic_equal_subst

cdpath+=(~)

zstyle ":acceptline:default" nocompwarn true
