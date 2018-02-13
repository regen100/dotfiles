# load settings
for i in $HOME/.zsh/*.zsh; do
  source $i
done

# load custom file
[[ -f $HOME/.zshrc.mine ]] && source $HOME/.zshrc.mine
