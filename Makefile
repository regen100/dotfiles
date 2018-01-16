.PHONY: root repo pip neovim clang python nodejs latex tmux byobu zsh wcwidth fbterm xrdp config

SHELL = bash
APT-INSTALL = apt-get install -y --no-install-recommends
PIP-INSTALL = /usr/bin/pip3 install -U
NPM-INSTALL = npm -g install

all:

root:
	@[ $$(id -u) -eq 0 ] || { echo "run as root"; exit 1; }

repo: root
	@if grep "//a" /etc/apt/sources.list > /dev/null; then \
		sed -ie "s#//a#//jp.a#g" /etc/apt/sources.list; \
		apt-get update; \
	fi
	@$(APT-INSTALL) software-properties-common wget

pip: repo
	@$(APT-INSTALL) python3-dev python3-pip python3-setuptools python3-wheel
	@$(PIP-INSTALL) pip

neovim: repo pip
	@if [ ! -f /etc/apt/sources.list.d/neovim-ppa-ubuntu-stable-xenial.list]; then \
		add-apt-repository -y ppa:neovim-ppa/stable; \
		apt-get update; \
	fi
	@$(APT-INSTALL) neovim silversearcher-ag git exuberant-ctags shellcheck xclip cmake
	@$(PIP-INSTALL) neovim vim-vint
	@update-alternatives --install /usr/bin/vi vi /usr/bin/nvim 60
	@update-alternatives --install /usr/bin/vim vim /usr/bin/nvim 60
	@update-alternatives --install /usr/bin/editor editor /usr/bin/nvim 60

clang: repo pip
	@if [ ! -f /etc/apt/sources.list.d/llvm.list ]; then \
		echo deb http://apt.llvm.org/xenial/ llvm-toolchain-xenial-5.0 main > /etc/apt/sources.list.d/llvm.list; \
		wget -qO - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add -; \
		apt-get update; \
	fi
	@$(APT-INSTALL) cmake build-essential llvm-5.0 clang-5.0 libclang-5.0-dev clang-tidy-5.0 clang-format-5.0 cppcheck
	@$(PIP-INSTALL) compdb cmakelint

python: pip
	@$(PIP-INSTALL) isort yapf flake8

nodejs: repo
	@if [ ! -f /etc/apt/sources.list.d/nodesource.list ]; then \
		wget -qO - https://deb.nodesource.com/setup_8.x | bash -; \
	fi
	@$(APT-INSTALL) nodejs
	@$(NPM-INSTALL) js-beautify

latex: repo
	@$(APT-INSTALL) texlive texlive-latex-extra texlive-lang-japanese latexmk chktex
	@kanji-config-updmap-sys auto

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

byobu: repo tmux
	@if [ ! -f /etc/apt/sources.list.d/byobu-ubuntu-ppa-xenial.list ]; then \
		add-apt-repository -y ppa:byobu/ppa; \
		apt-get update; \
	fi
	@$(APT-INSTALL) byobu

zsh: repo
	@$(APT-INSTALL) zsh command-not-found

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
		echo /usr/local/lib/wcwidth-cjk.so >> /etc/ld.so.preload; \
		apt-get purge -y --autoremove autoconf automake libtool; \
		rm -rf /tmp/wcwidth-cjk; \
	fi

fbterm: repo
	@$(APT-INSTALL) fbterm fcitx-frontend-fbterm gpm
	@chmod u+s /usr/bin/fbterm

xrdp: repo
	@add-apt-repository ppa:hermlnx/xrdp
	@apt-get update
	@$(APT-INSTALL) xrdp
	@sed -ie "s/allowed_users=console/allowed_users=anybody/" /etc/X11/Xwrapper.config

config:
	@DOT_DIRECTORY="$$HOME/dotfiles"; \
	DOT_CONFIG_DIRECTORY=".config"; \
	mkdir -p "$$HOME/$$DOT_CONFIG_DIRECTORY"; \
	cd "$$DOT_DIRECTORY"; \
	SRC=$$(find . -maxdepth 1 -name ".?*" ! -name $$DOT_CONFIG_DIRECTORY ! -name .git ! -name .gitignore -printf "%P\n"); \
	SRC=$$SRC"\n"$$(find $$DOT_CONFIG_DIRECTORY -maxdepth 1 ! -path $$DOT_CONFIG_DIRECTORY); \
	echo -ne "$$SRC" | xargs -i -d "\n" ln -snfv "$$DOT_DIRECTORY/{}" "$$HOME/{}"
	@[ "$$SHELL" = /usr/bin/zsh ] || chsh -s /usr/bin/zsh $$USER
