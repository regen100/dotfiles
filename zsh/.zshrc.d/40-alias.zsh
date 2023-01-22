alias xclip="xclip -selection clipboard"
alias g="git"
alias m="git m"
alias t="tig"
alias ap="ansible-playbook"

CMAKE_CXX_FLAGS="-fstandalone-debug -fcolor-diagnostics -march=native -ferror-limit=1 -g"
CMAKE_COMMON_OPTIONS=(-DBUILD_SHARED_LIBS=ON -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -DCMAKE_INSTALL_PREFIX=install -DBUILD_TESTING=ON)
CMAKE_SCCACHE=(-DCMAKE_CXX_COMPILER_LAUNCHER=sccache -DCMAKE_C_COMPILER_LAUNCHER=sccache)
alias -g CMAKE_DEV='"$CMAKE_SCCACHE[@]" -DCMAKE_CXX_COMPILER=clang++ -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_FLAGS="$CMAKE_CXX_FLAGS" -DCMAKE_C_FLAGS="$CMAKE_CXX_FLAGS" "$CMAKE_COMMON_OPTIONS[@]"'

if [[ -n $SSH_AUTH_SOCK ]]; then
  for i in ssh git rsync scp; do
    # shellcheck disable=SC2139,SC2004
    (( $+commands[$i] )) && alias $i="ssh-add -l >/dev/null || ssh-add; unalias $i 2>/dev/null; $i"
  done
fi
