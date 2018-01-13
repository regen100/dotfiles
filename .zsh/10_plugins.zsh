if [ ! -d ~/.zplug ]; then
  git clone https://github.com/zplug/zplug ~/.zplug
  source ~/.zplug/init.zsh && zplug update --self
fi
source ~/.zplug/init.zsh

zplug "yous/vanilli.sh"
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-completions"
zplug "chriskempson/base16-shell", hook-load:"base16_default-dark"
zplug "junegunn/fzf-bin", as:command, from:gh-r, rename-to:fzf
zplug "junegunn/fzf", as:command, use:bin/fzf-tmux
zplug "b4b4r07/enhancd", use:init.sh
zplug "modules/command-not-found", from:prezto
if [ $TERM != "linux" ] && [ ! -n "$MYVIMRC" ]; then
  zplug "bhilburn/powerlevel9k", use:powerlevel9k.zsh-theme, as:theme
fi

if ! zplug check --verbose; then
  zplug install
fi

POWERLEVEL9K_MODE='nerdfont-complete'
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(detect_virt ssh context dir_writable nodeenv virtualenv anaconda rbenv)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status background_jobs vcs dir time)
POWERLEVEL9K_SHORTEN_DIR_LENGTH=3
POWERLEVEL9K_SHORTEN_STRATEGY=truncate_from_right

wget -nc -qO ~/.dircolors https://github.com/dotphiles/dotzsh/raw/master/themes/dotphiles/dircolors/dircolors.base16.dark

zplug load
