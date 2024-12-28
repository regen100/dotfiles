alias xclip="xclip -selection clipboard"
alias g="git"
alias m="git m"
alias t="tig"
alias ap="ansible-playbook"
alias tf=terraform
alias tg=terragrunt
alias vi=nvim

CMAKE_CXX_FLAGS="-fstandalone-debug -ferror-limit=1 -g -O1 -W -Wall"
CMAKE_LDFLAGS=-fuse-ld=lld
alias -g CMAKE_DEV='\
  -DCMAKE_CXX_COMPILER_LAUNCHER=sccache -DCMAKE_C_COMPILER_LAUNCHER=sccache \
  -DCMAKE_CXX_COMPILER=clang++ -DCMAKE_C_COMPILER=clang \
  -DCMAKE_CXX_FLAGS="$CMAKE_CXX_FLAGS" -DCMAKE_C_FLAGS="$CMAKE_CXX_FLAGS" \
  -DCMAKE_EXE_LINKER_FLAGS="$CMAKE_LDFLAGS" -DCMAKE_SHARED_LINKER_FLAGS="$CMAKE_LDFLAGS" -DCMAKE_MODULE_LINKER_FLAGS="$CMAKE_LDFLAGS" \
  -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
  -DCMAKE_INSTALL_PREFIX=install \
  -DBUILD_TESTING=ON \
  -DCMAKE_BUILD_TYPE=Debug \
  -DCMAKE_COLOR_DIAGNOSTICS=ON'

if [[ -n $SSH_AUTH_SOCK ]]; then
  for i in ssh git rsync scp; do
    # shellcheck disable=SC2139,SC2004
    (( $+commands[$i] )) && alias $i="ssh-add -l >/dev/null || ssh-add; unalias $i 2>/dev/null; $i"
  done
fi
