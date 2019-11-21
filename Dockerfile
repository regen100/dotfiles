# hadolint ignore=DL3007
FROM archlinux

RUN pacman --noconfirm -Syuu && pacman --noconfirm -S base-devel git && rm /var/cache/pacman/pkg/*

RUN useradd -m -G wheel -s /usr/bin/zsh regen && echo "regen ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && echo 'Defaults env_keep += "HOME"' >> /etc/sudoers
ENV TERM xterm-256color
ENV LANG en_US.UTF-8
USER regen
WORKDIR /home/regen

COPY . dotfiles
RUN cd dotfiles \
      && make utils clang python rust nvim tmux-patch byobu zsh \
      && yay --noconfirm -Yc && sudo rm /var/cache/pacman/pkg/*

CMD ["zsh"]
