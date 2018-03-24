ifdef SUDO_USER
	CHANGE_USER := sudo -u "$$SUDO_USER"
else
	CHANGE_USER :=
endif

SHELL := bash
MAKEFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
DOTFILES_DIR := $(dir $(MAKEFILE_PATH))
APT-INSTALL := apt-get install -y --no-install-recommends
PIP-INSTALL := /usr/bin/pip3 install -U
STOW-INSTALL := $(CHNAGE_USER) stow -d $(DOTFILES_DIR) -t $(HOME)


.PHONY: all
all:

.PHONY: root
root:
	@[ $$(id -u) -eq 0 ] || { echo "run as root"; exit 1; }

.PHONY: repo
repo: root
	@if grep "//a" /etc/apt/sources.list > /dev/null; then \
		sed -ie "s#//a#//jp.a#g" /etc/apt/sources.list; \
		apt-get update; \
	fi
	@$(APT-INSTALL) software-properties-common wget

.PHONY: pip
pip: repo stow
	@$(APT-INSTALL) python3-dev python3-pip python3-setuptools python3-wheel python3-colorama
	@$(PIP-INSTALL) pip

.PHONY: utils
utils: root
	@$(APT-INSTALL) git-cola htop

.PHONY: deb
deb: root
	@$(APT-INSTALL) devscripts equivs

.PHONY: clean
clean:
	@apt-get purge -y --autoremove devscripts equivs

.PHONY: stow
stow: root
	@$(APT-INSTALL) stow

.PHONY: ctags
ctags: deb stow
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
nvim: repo pip ctags stow
	@if [ ! -f /etc/apt/sources.list.d/neovim-ppa-ubuntu-stable-xenial.list ]; then \
		add-apt-repository -y ppa:neovim-ppa/stable; \
		apt-get update; \
	fi
	@$(APT-INSTALL) neovim git shellcheck xclip cmake
	@$(PIP-INSTALL) neovim vim-vint neovim-remote
	@update-alternatives --install /usr/bin/vi vi /usr/bin/nvim 60
	@update-alternatives --install /usr/bin/vim vim /usr/bin/nvim 60
	@update-alternatives --install /usr/bin/editor editor /usr/bin/nvim 60
	@$(CHANGE_USER) mkdir -p ~/.config
	@$(STOW-INSTALL) nvim git
	@if ! which ag >/dev/null; then \
		wget http://mirrors.kernel.org/ubuntu/pool/universe/s/silversearcher-ag/silversearcher-ag_2.1.0-1_amd64.deb -O /tmp/silversearcher-ag.deb; \
		dpkg -i /tmp/silversearcher-ag.deb; \
		rm /tmp/silversearcher-ag.deb; \
	fi

.PHONY: clang
clang: repo pip
	@if [ ! -f /etc/apt/sources.list.d/ubuntu-toolchain-r-ubuntu-test-xenial.list ]; then \
		add-apt-repository -y ppa:ubuntu-toolchain-r/test; \
		apt-get update; \
	fi
	@$(APT-INSTALL) cmake make clang-5.0 libclang-5.0-dev clang-tidy-5.0 clang-format-5.0 cppcheck gdb libstdc++-7-dev
	@$(PIP-INSTALL) compdb cmakelint gdbgui
	@if ! which ccache >/dev/null; then \
		wget http://mirrors.kernel.org/ubuntu/pool/main/c/ccache/ccache_3.4.1-1_amd64.deb -O /tmp/ccache.deb; \
		dpkg -i /tmp/ccache.deb; \
		rm /tmp/ccache.deb; \
	fi

.PHONY: python
python: root pip
	@$(APT-INSTALL) virtualenv direnv
	@$(PIP-INSTALL) isort yapf flake8
	@$(STOW-INSTALL) python readline

.PHONY: nodejs
nodejs: repo
	@if [ ! -f /etc/apt/sources.list.d/nodesource.list ]; then \
		wget -qO - https://deb.nodesource.com/setup_8.x | bash -; \
	fi
	@$(APT-INSTALL) nodejs

.PHONY: rust
rust: stow
	@[ -d $$HOME/.cargo ] || curl https://sh.rustup.rs -sSf | $(CHANGE_USER) sh -s -- -y
	@$(CHANGE_USER) $$HOME/.cargo/bin/rustup update stable
	@$(CHANGE_USER) $$HOME/.cargo/bin/rustup install nightly
	@$(CHANGE_USER) $$HOME/.cargo/bin/rustup component add rust-src rustfmt-preview
	@$(CHANGE_USER) $$HOME/.cargo/bin/cargo +nightly install clippy || echo "clippy installed"
	@$(STOW-INSTALL) rust

.PHONY: plantuml
plantuml: root
	@$(APT-INSTALL) default-jre graphviz
	@if ! which plantuml >/dev/null; then \
		cat <(echo -e '#!/bin/sh\nexec /usr/bin/env java -jar "$$0" "$$@"') /tmp/plantuml > /usr/local/bin/plantuml; \
		chmod +x /usr/local/bin/plantuml; \
		rm /tmp/plantuml
	fi

.PHONY: latex
latex: root
	@$(APT-INSTALL) texlive texlive-latex-extra texlive-bibtex-extra texlive-lang-japanese latexmk chktex qpdfview fonts-ipafont fonts-ipaexfont
	@kanji-config-updmap-sys auto

.PHONY: tmux
tmux: deb
	@TMUX_VER=$$(dpkg -s tmux 2> /dev/null | grep ^Version: | cut -f 2 -d ' '); \
	if [ "$$TMUX_VER" != 2.6-3cjk ]; then \
		mkdir -p /tmp/build; \
		cd /tmp/build; \
		wget -O - http://http.debian.net/debian/pool/main/t/tmux/tmux_2.6.orig.tar.gz | tar zx; \
		wget -O - http://http.debian.net/debian/pool/main/t/tmux/tmux_2.6-3.debian.tar.xz | tar Jx -C tmux-2.6; \
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
		add-apt-repository -y ppa:byobu/ppa; \
		apt-get update; \
	fi
	@$(APT-INSTALL) byobu
	@$(CHANGE_USER) mkdir -p ~/.config
	@$(STOW-INSTALL) byobu
	@sed -i 's/^\(set -g .*-.*\)/#\1/g' /usr/share/byobu/keybindings/mouse.tmux.enable
	@sed -i 's/^\(set -g .*-.*\)/#\1/g' /usr/share/byobu/keybindings/mouse.tmux.disable

.PHONY: zsh
zsh: root pip stow
	@$(APT-INSTALL) zsh command-not-found ccze rlwrap
	@$(PIP-INSTALL) pygments pygments-base16
	@$(CHANGE_USER) mkdir -p ~/bin
	@$(STOW-INSTALL) zsh git readline
	@[ "$$SHELL" = $$HOME/bin/zsh-cjk ] || chsh -s $$HOME/bin/zsh-cjk $${SUDO_USER:-$$USER}

.PHONY: wcwidth
wcwidth: deb
	@if [ ! -f /usr/lib/wcwidth-cjk.so ]; then \
		mkdir -p /tmp/build; \
		cd /tmp/build; \
		git clone --depth=1 https://github.com/fumiyas/wcwidth-cjk.git wcwidth-cjk-0.0.0; \
		cd wcwidth-cjk-0.0.0; \
		cp -r $(DOTFILES_DIR).extras/wcwidth-cjk/debian .; \
		$(DOTFILES_DIR).extras/install_deb.sh; \
		rm -rf /tmp/build; \
	fi

.PHONY: fbterm
fbterm: root stow
	@$(APT-INSTALL) fbterm fcitx-frontend-fbterm gpm
	@chmod u+s /usr/bin/fbterm
	@$(STOW-INSTALL) fbterm

.PHONY: xrdp
xrdp: deb repo stow
	@if [ ! -f /etc/apt/sources.list.d/hermlnx-ubuntu-xrdp-xenial.list ]; then \
		add-apt-repository -y ppa:hermlnx/xrdp; \
		sed -i "s/^# *deb-src/deb-src/" /etc/apt/sources.list
		sed -i "s/^# *deb-src/deb-src/" /etc/apt/sources.list.d/hermlnx-ubuntu-xrdp-xenial.list
		apt-get update; \
	fi
	@$(APT-INSTALL) xrdp xscreensaver
	@sed -ie "s/allowed_users=console/allowed_users=anybody/" /etc/X11/Xwrapper.config
	@$(STOW-INSTALL) xsession
	@if [ ! -f /usr/lib/pulse-8.0/modules/module-xrdp-sink.so ]; then \
		mkdir -p /tmp/build; \
		cd /tmp/build; \
		apt-get source pulseaudio xrdp; \
		cd pulseaudio-*; \
		yes | mk-build-deps -i; \
		debian/rules configure/pulseaudio; \
		cd ../xrdp-*/sesman/chansrv/pulse; \
		make PULSE_DIR=../../../../pulseaudio-8.0; \
		install -s -m 644 *.so /usr/lib/pulse-8.0/modules; \
		apt-get purge -y --autoremove pulseaudio-build-deps; \
		rm -rf /ymp/build; \
	fi
	@echo -e "\e[31mPlease disable light-locker and enable XScreenSaver!\e[m"

.PHONY: font
font: repo deb
	@if [ ! -f /etc/apt/sources.list.d/fontforge-ubuntu-fontforge-xenial.list ]; then \
		add-apt-repository ppa:fontforge/fontforge; \
		apt-get update; \
	fi
	@mkdir -p /tmp/build; \
		cd /tmp/build; \
		echo -e "Package: build-deps\nDepends: fontforge (>= 20141231), python-configparser" > build-deps; \
		equivs-build build-deps; \
		dpkg -i build-deps_1.0_all.deb || $(APT-INSTALL) -f; \
		mkdir nerd-fonts; \
		cd nerd-fonts; \
		git init; \
		git config core.sparsecheckout true; \
		git remote add origin https://github.com/ryanoasis/nerd-fonts.git; \
		echo font-patcher >> .git/info/sparse-checkout; \
		echo src/glyphs >> .git/info/sparse-checkout; \
		git pull --depth=1 origin master; \
		cd ..; \
		mkdir data; \
		cd data; \
		wget http://www.rs.tus.ac.jp/yyusa/ricty/ricty_generator.sh; \
		wget https://github.com/google/fonts/raw/master/ofl/inconsolata/Inconsolata-Bold.ttf; \
		wget https://github.com/google/fonts/raw/master/ofl/inconsolata/Inconsolata-Regular.ttf; \
		wget http://dl.osdn.jp/mix-mplus-ipa/63545/migu-1m-20150712.zip; \
		unzip migu-1m-*; \
		ln -s migu-1m-*/*.ttf .; \
		sh ricty_generator.sh auto; \
		cd ..; \
		ls data/Ricty* | xargs -L1 fontforge -script nerd-fonts/font-patcher --complete --no-progressbars --quiet; \
		cp *.ttf /usr/local/share/fonts/ ;\
		fc-cache -fv; \
		rm -rf /tmp/build; \
		apt-get purge -y --autoremove build-deps

.PHONY: verilog
verilog: root
		@$(APT-INSTALL) iverilog gtkwave
		@if ! which iStyle >/dev/null; then \
			cd /tmp; \
			git clone -b v1.21 https://github.com/thomasrussellmurphy/istyle-verilog-formatter.git; \
			cd istyle-verilog-formatter; \
			make; \
			cp bin/release/iStyle /usr/local/bin; \
			rm -rf $$(pwd); \
		fi
