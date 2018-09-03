SHELL := bash
MAKEFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
DOTFILES_DIR := $(dir $(MAKEFILE_PATH))
APT-INSTALL := sudo apt-get install -y --no-install-recommends
PIP-INSTALL := sudo python3 -m pip install -U
STOW-INSTALL := stow -d $(DOTFILES_DIR) -t $(HOME)


.PHONY: all
all:

.PHONY: repo
repo:
	@if grep "//a" /etc/apt/sources.list > /dev/null; then \
		sudo sed -ie "s#//a#//jp.a#g" /etc/apt/sources.list; \
		sudo apt-get update; \
	fi
	@$(APT-INSTALL) software-properties-common wget

.PHONY: pip
pip: repo stow
	@$(APT-INSTALL) python3-dev python3-pip python3-setuptools python3-wheel

.PHONY: utils
utils:
	@$(APT-INSTALL) git-cola htop

.PHONY: deb
deb:
	@$(APT-INSTALL) devscripts equivs

.PHONY: clean
clean:
	@sudo apt-get purge -y --autoremove devscripts equivs

.PHONY: stow
stow:
	@$(APT-INSTALL) stow

.PHONY: git
git: stow
	@$(APT-INSTALL) git
	@$(STOW-INSTALL) git
	@if ! grep "\~/\.gitconfig_global" ~/.gitconfig >/dev/null; then \
		echo "[include]" >> ~/.gitconfig; \
		echo "	path = ~/.gitconfig_global" >> ~/.gitconfig; \
	fi

.PHONY: ctags
ctags: deb stow git
	@if [ ! -f /usr/bin/ctags ]; then \
		mkdir -p /tmp/build; \
		cd /tmp/build; \
		git clone --depth=1 https://github.com/universal-ctags/ctags.git universal-ctags-0.0.0; \
		cd universal-ctags-0.0.0; \
		cp -r $(DOTFILES_DIR).extras/universal-ctags/debian .; \
		$(DOTFILES_DIR).extras/install_deb.sh; \
		rm -rf /tmp/build; \
	fi
	@$(STOW-INSTALL) ctags

.PHONY: nvim
nvim: repo pip ctags stow git
	@if [ ! -f /etc/apt/sources.list.d/neovim-ppa-ubuntu-stable-xenial.list ]; then \
		sudo add-apt-repository -y ppa:neovim-ppa/stable; \
		sudo apt-get update; \
	fi
	@$(APT-INSTALL) neovim shellcheck xclip cmake
	@$(PIP-INSTALL) neovim vim-vint neovim-remote
	@sudo update-alternatives --install /usr/bin/vi vi /usr/bin/nvim 60
	@sudo update-alternatives --install /usr/bin/vim vim /usr/bin/nvim 60
	@sudo update-alternatives --install /usr/bin/editor editor /usr/bin/nvim 60
	@mkdir -p ~/.config
	@$(STOW-INSTALL) nvim
	@if ! which ag >/dev/null; then \
		wget http://mirrors.kernel.org/ubuntu/pool/universe/s/silversearcher-ag/silversearcher-ag_2.1.0-1_amd64.deb -O /tmp/silversearcher-ag.deb; \
		sudo dpkg -i /tmp/silversearcher-ag.deb; \
		rm /tmp/silversearcher-ag.deb; \
	fi
	@vi --headless "+call dein#install()" +qa

.PHONY: clang
clang: repo pip stow
	@if [ ! -f /etc/apt/sources.list.d/ubuntu-toolchain-r-ubuntu-test-xenial.list ]; then \
		sudo add-apt-repository -y ppa:ubuntu-toolchain-r/test; \
		sudo apt-get update; \
	fi
	@$(APT-INSTALL) cmake make ninja-build clang-5.0 libclang-5.0-dev clang-tidy-5.0 clang-format-5.0 cppcheck libstdc++-7-dev
	@$(PIP-INSTALL) compdb==0.1.1 cmakelint
	@if ! which ccache >/dev/null; then \
		wget http://mirrors.kernel.org/ubuntu/pool/main/c/ccache/ccache_3.4.1-1_amd64.deb -O /tmp/ccache.deb; \
		sudo dpkg -i /tmp/ccache.deb; \
		rm /tmp/ccache.deb; \
	fi
	@$(STOW-INSTALL) clang

.PHONY: python
python: pip
	@$(APT-INSTALL) virtualenv direnv python3-colorama
	@$(PIP-INSTALL) isort yapf flake8 hacking flake8-docstrings
	@$(STOW-INSTALL) python readline

.PHONY: nodejs
nodejs: repo
	@if [ ! -f /etc/apt/sources.list.d/nodesource.list ]; then \
		wget -qO - https://deb.nodesource.com/setup_8.x | sudo bash -; \
	fi
	@$(APT-INSTALL) nodejs

.PHONY: rust
rust: stow
	@[ -d $$HOME/.cargo ] || curl https://sh.rustup.rs -sSf | sh -s -- -y
	@$$HOME/.cargo/bin/rustup update stable
	@$$HOME/.cargo/bin/rustup install nightly
	@$$HOME/.cargo/bin/rustup component add rust-src rustfmt-preview
	@$(STOW-INSTALL) rust

.PHONY: plantuml
plantuml:
	@$(APT-INSTALL) default-jre graphviz
	@if ! which plantuml >/dev/null; then \
		wget -P /tmp http://sourceforge.net/projects/plantuml/files/plantuml.jar; \
		cat <(echo -e '#!/bin/sh\nexec /usr/bin/env java -jar "$$0" "$$@"') /tmp/plantuml.jar > /tmp/plantuml.new; \
		sudo cp -f /tmp/plantuml.new /usr/local/bin/plantuml; \
		sudo chmod +x /usr/local/bin/plantuml; \
		rm /tmp/plantuml.{jar,new}; \
	fi

.PHONY: latex
latex:
	@$(APT-INSTALL) texlive texlive-latex-extra texlive-bibtex-extra texlive-lang-japanese latexmk chktex qpdfview fonts-ipafont fonts-ipaexfont
	@sudo kanji-config-updmap-sys auto

.PHONY: tmux
tmux: deb
	@TMUX_VER=$$(dpkg -s tmux 2> /dev/null | grep ^Version: | cut -f 2 -d ' '); \
	if [ "$$TMUX_VER" != 2.6-3cjk ]; then \
		mkdir -p /tmp/build; \
		cd /tmp/build; \
		wget -O - http://archive.ubuntu.com/ubuntu/pool/main/t/tmux/tmux_2.6.orig.tar.gz | tar zx; \
		wget -O - http://archive.ubuntu.com/ubuntu/pool/main/t/tmux/tmux_2.6-3.debian.tar.xz | tar Jx -C tmux-2.6; \
		cd tmux-2.6; \
		wget -qO debian/patches/cjk.diff https://gist.github.com/z80oolong/e65baf0d590f62fab8f4f7c358cbcc34/raw/a3b687808c8fd5b8ad67e9a9b81774bb189fa93c/tmux-2.6-fix.diff; \
		echo cjk.diff >> debian/patches/series; \
		dch -v 2.6-3cjk "CJK patch"; \
		$(DOTFILES_DIR).extras/install_deb.sh; \
		rm -rf /tmp/build; \
	fi

.PHONY: byobu
byobu: repo tmux stow
	@if [ ! -f /etc/apt/sources.list.d/byobu-ubuntu-ppa-xenial.list ]; then \
		sudo add-apt-repository -y ppa:byobu/ppa; \
		sudo apt-get update; \
	fi
	@$(APT-INSTALL) byobu
	@mkdir -p ~/.config
	@$(STOW-INSTALL) byobu
	@sudo sed -i 's/^\(set -g .*-.*\)/#\1/g' /usr/share/byobu/keybindings/mouse.tmux.enable
	@sudo sed -i 's/^\(set -g .*-.*\)/#\1/g' /usr/share/byobu/keybindings/mouse.tmux.disable

.PHONY: zsh
zsh: pip stow git wcwidth
	@$(APT-INSTALL) zsh command-not-found ccze rlwrap wget
	@$(PIP-INSTALL) pygments pygments-base16
	@mkdir -p ~/bin
	@$(STOW-INSTALL) zsh readline
	@wcwidth-cjk zsh -ic exit </dev/null

.PHONY: wcwidth
wcwidth: deb git
	@if [ ! -f /usr/lib/wcwidth-cjk.so ]; then \
		mkdir -p /tmp/build; \
		cd /tmp/build; \
		git clone --depth=1 https://github.com/fumiyas/wcwidth-cjk.git wcwidth-cjk-0.0.0; \
		cd wcwidth-cjk-0.0.0; \
		cp -r $(DOTFILES_DIR).extras/wcwidth-cjk/debian .; \
		$(DOTFILES_DIR).extras/install_deb.sh; \
		rm -rf /tmp/build; \
	fi

.PHONY: xrdp
xrdp: repo stow
	@if [ ! -f /etc/apt/sources.list.d/hermlnx-ubuntu-xrdp-xenial.list ]; then \
		sudo add-apt-repository -y ppa:hermlnx/xrdp; \
		sudo apt-get update; \
	fi
	@$(APT-INSTALL) xrdp xscreensaver
	@sudo sed -ie "s/allowed_users=console/allowed_users=anybody/" /etc/X11/Xwrapper.config
	@$(STOW-INSTALL) xsession
	@echo -e "\e[31mPlease disable light-locker and enable XScreenSaver!\e[m"

.PHONY: font
font:
	@$(APT-INSTALL) fonts-ipaexfont
	@wget https://github.com/miiton/Cica/releases/download/v3.0.0-rc1/Cica_v3.0.0-rc1.zip -O /tmp/cica.zip
	@unzip /tmp/cica.zip -d /tmp/cica
	@sudo cp /tmp/cica/*.ttf /usr/local/share/fonts/
	@rm -rf /tmp/cica.zip /tmp/cica
	@sudo fc-cache -fv

.PHONY: verilog
verilog: git
	@$(APT-INSTALL) iverilog gtkwave
	@if ! which iStyle >/dev/null; then \
		cd /tmp; \
		git clone -b v1.21 https://github.com/thomasrussellmurphy/istyle-verilog-formatter.git; \
		cd istyle-verilog-formatter; \
		make; \
		sudo cp bin/release/iStyle /usr/local/bin; \
		rm -rf $$(pwd); \
	fi

.PHONY: gotty
gotty:
	@mkdir -p ~/bin
	@wget -O - https://github.com/yudai/gotty/releases/download/v2.0.0-alpha.3/gotty_2.0.0-alpha.3_linux_amd64.tar.gz | tar -zxC ~/bin

.PHONY: gdb
gdb: stow
	@$(APT-INSTALL) gdb
	@$(STOW-INSTALL) gdb

.PHONY: apt-proxy
apt-proxy:
	@$(APT-INSTALL) squid-deb-proxy squid-deb-proxy-client
	@# squid
	@sudo systemctl stop squid.service
	@sudo systemctl disable squid.service 2>/dev/null
	@# squid-deb-proxy
	@cnf=/etc/squid-deb-proxy/squid-deb-proxy.conf; \
		grep -q "http_port 8001" $$cnf || sudo sed -i "/http_port /a http_port 8001 intercept" $$cnf; \
		sudo sed -i "s/^\(http_access deny !to_archive_mirrors\)/#\1/" $$cnf
	@sudo sed -i 's/^#\(\w\)/\1/' /etc/squid-deb-proxy/mirror-dstdomain.acl.d/10-default
	@wget -qO- http://mirrors.ubuntu.com/mirrors.txt | grep -oP '(?<=://).+?(?=/)' | grep -v archive.ubuntu.com | sudo tee /etc/squid-deb-proxy/mirror-dstdomain.acl.d/20-mirrors >/dev/null
	@sudo systemctl reload squid-deb-proxy.service
	@# DNAT
	@sudo cp -f $(DOTFILES_DIR).extras/apt-proxy/systemd/apt-proxy.service /etc/systemd/system
	@sudo systemctl daemon-reload
	@sudo systemctl enable apt-proxy.service
	@sudo systemctl start apt-proxy.service
