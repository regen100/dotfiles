# hadolint ignore=DL3007
FROM archlinux

RUN pacman --noconfirm -Syuu && pacman --noconfirm -S base-devel git zsh && rm /var/cache/pacman/pkg/*

RUN useradd -m -g wheel -s /usr/bin/zsh regen \
  && echo "regen ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers \
  && echo 'Defaults env_keep += "HOME"' >> /etc/sudoers \
  && echo "Set disable_coredump false" >> /etc/sudo.conf
ENV TERM xterm-256color
ENV LANG en_US.UTF-8
USER regen
WORKDIR /home/regen

COPY --chown=regen:wheel . dotfiles
RUN cd dotfiles \
  && sudo pacman -Sy \
  && make utils clang python rust nvim tmux-patch byobu zsh \
  && yay --noconfirm -Yc && sudo rm /var/cache/pacman/pkg/*

CMD ["zsh"]
