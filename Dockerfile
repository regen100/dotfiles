# hadolint ignore=DL3007
FROM archlinux:latest

RUN pacman --noconfirm -Syuu && pacman --noconfirm -S base-devel git zsh && rm /var/cache/pacman/pkg/*

RUN useradd -m -g wheel -s /usr/bin/zsh regen \
  && echo "regen ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers \
  && echo 'Defaults env_keep += "HOME"' >> /etc/sudoers \
  && echo "Set disable_coredump false" >> /etc/sudo.conf

WORKDIR /home/regen
COPY --chown=regen:wheel . dotfiles
WORKDIR /home/regen/dotfiles
RUN su regen sh -c "make zsh utils clang python rust nvim tmux" \
  && rm /var/cache/pacman/pkg/*

USER regen
WORKDIR /home/regen
ENV LANG en_US.UTF-8
CMD ["zsh", "-l"]
