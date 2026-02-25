eval "$(uv generate-shell-completion zsh)"

eval "$(zoxide init --cmd cd zsh)"

if [[ ! -f ~/.fzf.zsh ]]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --all --no-update-rc
fi
source <(fzf --zsh)

if command -v docker &>/dev/null; then
  mkdir -p ~/.zsh/completions
  docker completion zsh > ~/.zsh/completions/_docker
fi

if command -v aws_completer &>/dev/null; then
  autoload -Uz bashcompinit && bashcompinit
  complete -C aws_completer aws
fi

[ -s "${HOME}/.bun/_bun" ] && source "${HOME}/.bun/_bun"
