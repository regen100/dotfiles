if [ $TERM = "linux" ]; then
  export LANG=en_US.UTF-8
fi

# zplug
if [ ! -d ~/.zplug ]; then
  git clone https://github.com/zplug/zplug ~/.zplug
  source ~/.zplug/init.zsh && zplug update --self
fi
source ~/.zplug/init.zsh

zplug "yous/vanilli.sh"
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-completions"
zplug "chriskempson/base16-shell", hook-load:"base16_default-dark"
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

# set
bindkey -e

zstyle ':completion:*' use-cache true
zstyle ':completion:*:default' menu select=2

# color
alias ls='ls --color=auto'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# history
bindkey '^P' history-beginning-search-backward
bindkey '^N' history-beginning-search-forward

# weather
wttr() {
  curl -H "Accept-Language: ${LANG%_*}" wttr.in/"${1}"
}

# misc
[ -f /etc/zsh_command_not_found ] && source /etc/zsh_command_not_found

# cdls
chpwd() {
  ls_abbrev
}
ls_abbrev() {
  # -a : Do not ignore entries starting with ..
  # -C : Force multi-column output.
  # -F : Append indicator (one of */=>@|) to entries.
  local cmd_ls='ls'
  local -a opt_ls
  opt_ls=('-aCF' '--color=always')
  case "${OSTYPE}" in
    freebsd*|darwin*)
      if type gls > /dev/null 2>&1; then
        cmd_ls='gls'
      else
        # -G : Enable colorized output.
        opt_ls=('-aCFG')
      fi
      ;;
  esac

  local ls_result
  ls_result=$(CLICOLOR_FORCE=1 COLUMNS=$COLUMNS command $cmd_ls ${opt_ls[@]} | sed $'/^\e\[[0-9;]*m$/d')

  local ls_lines=$(echo "$ls_result" | wc -l | tr -d ' ')

  if [ $ls_lines -gt 10 ]; then
    echo "$ls_result" | head -n 5
    echo '...'
    echo "$ls_result" | tail -n 5
    echo "$(command ls -1 -A | wc -l | tr -d ' ') files exist"
  else
    echo "$ls_result"
  fi
}

# path
path+='~/bin'
if [ -d /usr/lib/llvm-5.0 ]; then
  path+='/usr/lib/llvm-5.0/bin/'
fi
export PATH

# load custom file
[ -f ${HOME}/.zshrc.mine ] && source ${HOME}/.zshrc.mine
