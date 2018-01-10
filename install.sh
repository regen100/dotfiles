#!/bin/bash

# For Ubuntu 16.04

# repo
if grep "//a" /etc/apt/sources.list > /dev/null; then
  sudo sed -ie "s#//a#//jp.a#g" /etc/apt/sources.list
  sudo apt-get update
fi

sudo apt-get install -y --no-install-recommends software-properties-common

if [ ! -f /usr/bin/nvim ]; then
  sudo add-apt-repository -y ppa:neovim-ppa/stable
fi
if [ ! -f /etc/apt/sources.list.d/byobu-ubuntu-ppa-xenial.list ]; then
  sudo add-apt-repository -y ppa:byobu/ppa
fi
if [ ! -f /etc/apt/sources.list.d/llvm.list ]; then
  sudo sh -c "echo deb http://apt.llvm.org/xenial/ llvm-toolchain-xenial-5.0 main > /etc/apt/sources.list.d/llvm.list"
  wget -qO - https://apt.llvm.org/llvm-snapshot.gpg.key | sudo apt-key add -
fi
if [ ! -f /etc/apt/sources.list.d/nodesource.list ]; then
  curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
fi
sudo apt-get update
sudo apt-get install -y --no-install-recommends \
  neovim zsh byobu tmux silversearcher-ag \
  git cmake build-essential \
  python3-dev python3-pip python3-setuptools python3-wheel \
  llvm-5.0 clang-5.0 libclang-5.0-dev clang-tidy-5.0 clang-format-5.0 cppcheck \
  exuberant-ctags flake8 shellcheck chktex \
  nodejs
sudo /usr/bin/pip3 install -U \
  pip \
  neovim \
  compdb \
  isort yapf \
  vim-vint \
  cmakelint
sudo npm -g install js-beautify

sudo update-alternatives --install /usr/bin/vi vi /usr/bin/nvim 60
sudo update-alternatives --install /usr/bin/vim vim /usr/bin/nvim 60
sudo update-alternatives --install /usr/bin/editor editor /usr/bin/nvim 60

# update tmux
TMUX_VER=$(dpkg -s tmux | grep ^Version: | cut -f 2 -d ' ')
if [ "$TMUX_VER" != 2.6-3cjk ]; then (
  cd /tmp
  sudo apt-get install -y --no-install-recommends devscripts equivs
  curl -fsSL http://http.debian.net/debian/pool/main/t/tmux/tmux_2.6.orig.tar.gz | tar zx
  curl -fsSL http://http.debian.net/debian/pool/main/t/tmux/tmux_2.6-3.debian.tar.xz | tar Jx -C tmux-2.6
  cd tmux-2.6
  curl -fsSL https://gist.github.com/z80oolong/e65baf0d590f62fab8f4f7c358cbcc34/raw/a3b687808c8fd5b8ad67e9a9b81774bb189fa93c/tmux-2.6-fix.diff | patch -p1
  dch -v 2.6-3cjk "CJK patch"
  yes | sudo mk-build-deps -i
  debuild -us -uc -b
  cd ..
  sudo apt purge -y --autoremove tmux-build-deps devscripts equivs
  sudo dpkg -i tmux*.deb
  rm -rf tmux*
); fi

# wcwidth-cjk
if [ ! -f /usr/local/lib/wcwidth-cjk.so ]; then
  cd /tmp
  git clone https://github.com/fumiyas/wcwidth-cjk.git
  cd wcwidth-cjk
  sudo apt-get install -y --no-install-recommends autoconf automake libtool
  autoreconf --install
  ./configure --prefix=/usr/local/
  make
  sudo make install
  sudo sh -c "echo /usr/local/lib/wcwidth-cjk.so >> /etc/ld.so.preload"
  rm -rf "$PWD"
fi

# install
DOT_DIRECTORY="$HOME/dotfiles"
DOT_CONFIG_DIRECTORY=".config"
mkdir -p "$HOME/$DOT_CONFIG_DIRECTORY"
cd "$DOT_DIRECTORY"
SRC=$(find . -maxdepth 1 -name ".?*" ! -name $DOT_CONFIG_DIRECTORY ! -name .git -printf "%P\n")
SRC=$SRC"\n"$(find $DOT_CONFIG_DIRECTORY -maxdepth 1 ! -path $DOT_CONFIG_DIRECTORY)
echo -ne "$SRC" | xargs -i -d "\n" ln -snfv "$DOT_DIRECTORY/{}" "$HOME/{}"
sudo chsh -s /usr/bin/zsh "$USER"
