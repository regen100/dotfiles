# hadolint ignore=DL3007
FROM archlinuxjp/archlinux:latest

RUN pacman --noconfirm -Syuu && pacman --noconfirm -S base-devel git && rm /var/cache/pacman/pkg/*

RUN useradd -m -G wheel -s /usr/bin/zsh regen && echo "regen ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && echo 'Defaults env_keep += "HOME"' >> /etc/sudoers
ENV TERM xterm-256color
ENV LANG en_US.UTF-8

RUN su regen -s /usr/bin/sh -c "git clone https://github.com/regen100/dotfiles.git ~/dotfiles && cd ~/dotfiles && make utils clang rust python nvim byobu zsh" \
 && yay --noconfirm -Yc && rm /var/cache/pacman/pkg/*

USER regen
WORKDIR /home/regen
CMD ["byobu"]
