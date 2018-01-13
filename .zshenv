# path
if [ -z $ZSHENV_LOADED ]; then
  path+='~/bin'
  if [ -d /usr/lib/llvm-5.0 ]; then
    path+='/usr/lib/llvm-5.0/bin/'
  fi
  export PATH
  export ZSHENV_LOADED=1
fi
