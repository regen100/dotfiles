export FZF_DEFAULT_COMMAND="rg --files --hidden --glob '!**/.git/' 2>/dev/null"
_fzf_compgen_path() {
  rg --files --hidden --glob '!**/.git/' 2>/dev/null
}
_fzf_compgen_dir() {
	rg --files --null --sort path 2>/dev/null | xargs -0 dirname | uniq
}
export FZF_CTRL_T_COMMAND=_fzf_compgen_path

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
