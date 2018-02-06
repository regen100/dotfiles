if [ ! -d ~/.zplug ]; then
  git clone https://github.com/zplug/zplug ~/.zplug
fi
source ~/.zplug/init.zsh

zstyle ":zplug:tag" depth 1

zplug "yous/vanilli.sh"
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-autosuggestions"
zplug "chriskempson/base16-shell", hook-load:"base16_default-dark"
zplug "junegunn/fzf-bin", as:command, from:gh-r, rename-to:fzf
zplug "junegunn/fzf", as:command, use:bin/fzf-tmux
zplug "b4b4r07/enhancd", use:init.sh
zplug "modules/command-not-found", from:prezto
zplug "mollifier/cd-bookmark", hook-load:"alias cdb=cd-bookmark"
zplug "docker/compose", use:contrib/completion/zsh, if:"(( $+commands[docker-compose] ))"
zplug "rust-lang/zsh-config", use:src, if:"(( $+commands[rustc] ))"
zplug "lukechilds/zsh-better-npm-completion", if:"(( $+commands[npm] ))"

zplug "caarlos0/zsh-mkc"
zplug "marzocchi/zsh-notify", if:"(( $+commands[xdotool] )) && xdotool getactivewindow > /dev/null"

zplug "plugins/colored-man-pages", from:oh-my-zsh
zplug "plugins/common-aliases", from:oh-my-zsh
zplug "plugins/python", from:oh-my-zsh
zplug "plugins/pip", from:oh-my-zsh
zplug "plugins/sudo", from:oh-my-zsh

if [ $TERM != "linux" ] && [ ! -n "$MYVIMRC" ]; then
  zplug "bhilburn/powerlevel9k", use:powerlevel9k.zsh-theme, as:theme
else
  zplug "mafredri/zsh-async"
  zplug "sindresorhus/pure", use:pure.zsh, as:theme
fi

if ! zplug check; then
  zplug install
fi

POWERLEVEL9K_MODE='nerdfont-complete'
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(detect_virt ssh context dir_writable nodeenv virtualenv anaconda rbenv)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status background_jobs vcs dir time)
POWERLEVEL9K_SHORTEN_DIR_LENGTH=3
POWERLEVEL9K_SHORTEN_STRATEGY=truncate_from_right

wget -nc -qO ~/.dircolors https://github.com/dotphiles/dotzsh/raw/master/themes/dotphiles/dircolors/dircolors.base16.dark

zplug load
