SHELL := bash
MAKEFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
DOTFILES_DIR := $(dir $(MAKEFILE_PATH))
APT-INSTALL := apt-get install -y --no-install-recommends
PIP-INSTALL := /usr/bin/pip3 install -U

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
pip: repo
	@$(APT-INSTALL) python3-dev python3-pip python3-setuptools python3-wheel
	@$(PIP-INSTALL) pip

.PHONY: neovim
neovim: repo pip
	@if [ ! -f /etc/apt/sources.list.d/neovim-ppa-ubuntu-stable-xenial.list ]; then \
		add-apt-repository -y ppa:neovim-ppa/stable; \
		apt-get update; \
	fi
	@$(APT-INSTALL) neovim silversearcher-ag git exuberant-ctags shellcheck xclip cmake
	@$(PIP-INSTALL) neovim vim-vint
	@update-alternatives --install /usr/bin/vi vi /usr/bin/nvim 60
	@update-alternatives --install /usr/bin/vim vim /usr/bin/nvim 60
	@update-alternatives --install /usr/bin/editor editor /usr/bin/nvim 60

.PHONY: clang
clang: repo pip
	@if [ ! -f /etc/apt/sources.list.d/llvm.list ]; then \
		echo deb http://apt.llvm.org/xenial/ llvm-toolchain-xenial-5.0 main > /etc/apt/sources.list.d/llvm.list; \
		wget -qO - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add -; \
		apt-get update; \
	fi
	@$(APT-INSTALL) cmake build-essential llvm-5.0 clang-5.0 libclang-5.0-dev clang-tidy-5.0 clang-format-5.0 cppcheck
	@$(PIP-INSTALL) compdb cmakelint
	@if ! which ccache >/dev/null; then \
		wget http://mirrors.kernel.org/ubuntu/pool/main/c/ccache/ccache_3.3.6-1_amd64.deb -O /tmp/ccache.deb; \
		dpkg -i /tmp/ccache.deb; \
		rm /tmp/ccache.deb; \
	fi

.PHONY: python
python: repo pip
	@$(APT-INSTALL) virtualenv direnv
	@$(PIP-INSTALL) isort yapf flake8

.PHONY: nodejs
nodejs: repo
	@if [ ! -f /etc/apt/sources.list.d/nodesource.list ]; then \
		wget -qO - https://deb.nodesource.com/setup_8.x | bash -; \
	fi
	@$(APT-INSTALL) nodejs

.PHONY: rust
rust:
	@curl https://sh.rustup.rs -sSf | sh -s -- -y
	@$$HOME/.cargo/bin/rustup component add rust-src
	@$$HOME/.cargo/bin/rustup install nightly
	@$$HOME/.cargo/bin/rustup component add rustfmt-preview --toolchain=nightly
	@[ -n "$$SUDO_USER" ] || chown -R $$SUDO_UID:$$SUDO_GID $$HOME/.cargo $$HOME/.rustup

.PHONY: latex
latex: repo
	@$(APT-INSTALL) texlive texlive-latex-extra texlive-lang-japanese latexmk chktex
	@kanji-config-updmap-sys auto

.PHONY: tmux
tmux: repo
	@TMUX_VER=$$(dpkg -s tmux 2> /dev/null | grep ^Version: | cut -f 2 -d ' '); \
	if [ "$$TMUX_VER" != 2.6-3cjk ]; then \
		mkdir -p /tmp/tmux-build; \
		cd /tmp/tmux-build; \
		$(APT-INSTALL) devscripts equivs; \
		wget -qO - http://http.debian.net/debian/pool/main/t/tmux/tmux_2.6.orig.tar.gz | tar zx; \
		wget -qO - http://http.debian.net/debian/pool/main/t/tmux/tmux_2.6-3.debian.tar.xz | tar Jx -C tmux-2.6; \
		cd tmux-2.6; \
		wget -qO - https://gist.github.com/z80oolong/e65baf0d590f62fab8f4f7c358cbcc34/raw/a3b687808c8fd5b8ad67e9a9b81774bb189fa93c/tmux-2.6-fix.diff | patch -p1; \
		dch -v 2.6-3cjk "CJK patch"; \
		yes | mk-build-deps -i; \
		debuild -us -uc -b; \
		cd ..; \
		apt-get purge -y --autoremove tmux-build-deps devscripts equivs; \
		dpkg -i tmux*.deb || apt-get -fy install; \
		rm -rf /tmp/tmux-build; \
	fi

.PHONY: byobu
byobu: repo tmux
	@if [ ! -f /etc/apt/sources.list.d/byobu-ubuntu-ppa-xenial.list ]; then \
		add-apt-repository -y ppa:byobu/ppa; \
		apt-get update; \
	fi
	@$(APT-INSTALL) byobu

.PHONY: zsh
zsh: repo
	@$(APT-INSTALL) zsh command-not-found
	@[ "$$SHELL" = $$HOME/dotfiles/bin/zsh-cjk ] || chsh -s $$HOME/dotfiles/bin/zsh-cjk $${SUDO_USER:-$$USER}

.PHONY: wcwidth
wcwidth: repo
	@if [ ! -f /usr/local/lib/wcwidth-cjk.so ]; then \
		$(APT-INSTALL) git autoconf automake libtool build-essential; \
		cd /tmp; \
		git clone https://github.com/fumiyas/wcwidth-cjk.git; \
		cd wcwidth-cjk; \
		autoreconf --install; \
		./configure --prefix=/usr/local; \
		make; \
		make install; \
		apt-get purge -y --autoremove autoconf automake libtool; \
		rm -rf /tmp/wcwidth-cjk; \
	fi

.PHONY: fbterm
fbterm: repo
	@$(APT-INSTALL) fbterm fcitx-frontend-fbterm gpm
	@chmod u+s /usr/bin/fbterm

.PHONY: xrdp
xrdp: repo
	@add-apt-repository -y ppa:hermlnx/xrdp
	@apt-get update
	@$(APT-INSTALL) xrdp xscreensaver
	@sed -ie "s/allowed_users=console/allowed_users=anybody/" /etc/X11/Xwrapper.config
	@echo -e "\e[31mPlease disable light-locker and enable XScreenSaver!\e[m"

.PHONY: config
config:
	@mkdir -p "$$HOME/.config"; \
	cd "$(DOTFILES_DIR)"; \
	SRC=$$(find . -maxdepth 1 -name ".?*" ! -name .config ! -name .git ! -name .gitignore -printf "%P\n"); \
	SRC=$$SRC"\n"$$(find .config -maxdepth 1 ! -path .config); \
	echo -ne "$$SRC" | xargs -i -d "\n" ln -snfv "$(DOTFILES_DIR){}" "$$HOME/{}"
