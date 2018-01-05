#!/bin/bash

# For Ubuntu 16.04

# repo
if grep "//a" /etc/apt/sources.list > /dev/null; then
  sudo sed -ie "s#//a#//jp.a#g" /etc/apt/sources.list
fi

sudo apt-get update
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
  neovim zsh byobu tmux \
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
TMUX_VER=$(tmux -V | cut -f 2 -d' ')
TMUX_NEW_VER=$(printf "%s\n2.2" "$TMUX_VER" | sort -V | head -n 1)
if [ "$TMUX_NEW_VER" != 2.2 ]; then
  wget -O /tmp/tmux.deb http://launchpadlibrarian.net/263289132/tmux_2.2-3_amd64.deb
  sudo dpkg -i /tmp/tmux.deb
  rm /tmp/tmux.deb
fi
if [ ! -d "$HOME/.config/byobu/plugins/tpm" ]; then
  git clone https://github.com/tmux-plugins/tpm ~/.config/byobu/plugins/tpm
fi

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
