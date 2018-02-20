ifdef SUDO_USER
	CHNAGE_USER := sudo -u "$$SUDO_USER"
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
	@$(APT-INSTALL) git-extras git-cola

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
ctags: deb
	@if [ ! -f /usr/bin/ctags ]; then \
		mkdir -p /tmp/build; \
		cd /tmp/build; \
		git clone --depth=1 https://github.com/universal-ctags/ctags.git universal-ctags-0.0.0; \
		cd universal-ctags-0.0.0; \
		cp -r $(DOTFILES_DIR).extras/universal-ctags/debian .; \
		$(DOTFILES_DIR).extras/install_deb.sh; \
		rm -rf /tmp/build; \
	fi

.PHONY: nvim
nvim: repo pip ctags stow
	@if [ ! -f /etc/apt/sources.list.d/neovim-ppa-ubuntu-stable-xenial.list ]; then \
		add-apt-repository -y ppa:neovim-ppa/stable; \
		apt-get update; \
	fi
	@$(APT-INSTALL) neovim silversearcher-ag git shellcheck xclip cmake
	@$(PIP-INSTALL) neovim vim-vint
	@update-alternatives --install /usr/bin/vi vi /usr/bin/nvim 60
	@update-alternatives --install /usr/bin/vim vim /usr/bin/nvim 60
	@update-alternatives --install /usr/bin/editor editor /usr/bin/nvim 60
	@$(STOW-INSTALL) nvim

.PHONY: clang
clang: repo pip
	@if [ ! -f /etc/apt/sources.list.d/llvm.list ]; then \
		echo deb http://apt.llvm.org/xenial/ llvm-toolchain-xenial-5.0 main > /etc/apt/sources.list.d/llvm.list; \
		wget -qO - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add -; \
		apt-get update; \
	fi
	@$(APT-INSTALL) cmake build-essential llvm-5.0 clang-5.0 libclang-5.0-dev clang-tidy-5.0 clang-format-5.0 cppcheck gdb lldb-5.0
	@$(PIP-INSTALL) compdb cmakelint gdbgui
	@if ! which ccache >/dev/null; then \
		wget http://mirrors.kernel.org/ubuntu/pool/main/c/ccache/ccache_3.3.6-1_amd64.deb -O /tmp/ccache.deb; \
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
rust: root
	@$(CHANGE_USER) curl https://sh.rustup.rs -sSf | sh -s -- -y
	@$(CHANGE_USER) $$HOME/.cargo/bin/rustup component add rust-src
	@$(CHANGE_USER) $$HOME/.cargo/bin/rustup install nightly
	@$(CHANGE_USER) $$HOME/.cargo/bin/rustup component add rustfmt-preview
	@$(APT-INSTALL) libssl-dev
	@$(CHANGE_USER) $$HOME/.cargo/bin/cargo install -f cargo-tree cargo-edit
	@$(CHANGE_USER) $$HOME/.cargo/bin/cargo +nightly install -f clippy

.PHONY: latex
latex: root
	@$(APT-INSTALL) texlive texlive-latex-extra texlive-lang-japanese latexmk chktex
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
	@$(STOW-INSTALL) byobu

.PHONY: zsh
zsh: root pip stow
	@$(APT-INSTALL) zsh command-not-found
	@$(PIP-INSTALL) pygments pygments-base16
	@$(STOW-INSTALL) zsh
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
xrdp: repo stow
	@add-apt-repository -y ppa:hermlnx/xrdp
	@apt-get update
	@$(APT-INSTALL) xrdp xscreensaver
	@sed -ie "s/allowed_users=console/allowed_users=anybody/" /etc/X11/Xwrapper.config
	@echo -e "\e[31mPlease disable light-locker and enable XScreenSaver!\e[m"
	@$(STOW-INSTALL) xsession

