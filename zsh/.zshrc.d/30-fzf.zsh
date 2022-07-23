export FZF_DEFAULT_COMMAND="rg --files 2>/dev/null"
_fzf_compgen_path() {
  rg --files 2>/dev/null
}
_fzf_compgen_dir() {
	rg --files --null --sort path 2>/dev/null | xargs -0 dirname | uniq
}
export FZF_CTRL_T_COMMAND=_fzf_compgen_path

[[ -e /usr/share/fzf/completion.zsh ]] && source /usr/share/fzf/completion.zsh
[[ -e /opt/homebrew/opt/fzf/shell/completion.zsh ]] && source /opt/homebrew/opt/fzf/shell/completion.zsh

[[ -e /usr/share/fzf/key-bindings.zsh ]] && source /usr/share/fzf/key-bindings.zsh
[[ -e /opt/homebrew/opt/fzf/shell/key-bindings.zsh ]] && source /opt/homebrew/opt/fzf/shell/key-bindings.zsh

if (( $+commands[ghq] )) && (( $+functions[__fzfcmd] )); then
  ghq-fzf() {
    local src
    src=$(ghq list | $(__fzfcmd) --preview "ls --color=always -aghvF $(ghq root)/{} | tail -n+4")
    if [[ -n $src ]]; then
      # shellcheck disable=SC2034
      BUFFER="cd -- $(ghq root)/$src"
      zle accept-line
    fi
  }

  zle -N ghq-fzf
  bindkey "^]" ghq-fzf
fi
