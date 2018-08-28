# wcwidth
[[ -z $LD_PRELOAD && $+commands[wcwidth-cjk] -eq 1 ]] && exec wcwidth-cjk $0 -l

# load settings
for i in $HOME/.zsh/*.zsh; do
  source $i
done

# load custom file
[[ -f $HOME/.zshrc.mine ]] && source $HOME/.zshrc.mine

# profiling
(( $+modules[zsh/zprof] )) && zprof

true
