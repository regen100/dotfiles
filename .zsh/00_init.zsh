if [[ $TERM == "linux" ]]; then
  export LANG=en_US.UTF-8
fi
if [[ -n $FBTERM ]]; then
  export TERM=fbterm
fi
