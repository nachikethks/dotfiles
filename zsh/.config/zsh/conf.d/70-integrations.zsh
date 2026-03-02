# Cache eval-based init scripts to avoid spawning processes on every shell start.
# Regenerates automatically when the binary is updated.
_cached_source() {
  local cmd="$1"; shift
  local cache="$HOME/.zsh/cache/${cmd##*/}.zsh"
  local bin_path="${commands[$cmd]}"

  if [[ ! -f "$cache" || ( -n "$bin_path" && "$bin_path" -nt "$cache" ) ]]; then
    mkdir -p "${cache:h}"
    "$cmd" "$@" > "$cache" 2>/dev/null
  fi
  source "$cache"
}

_cached_source starship init zsh
_cached_source zoxide init --cmd cd zsh
_cached_source fzf --zsh

# Lazy-load uv completions on first use
if (( $+commands[uv] )); then
  uv() {
    unfunction uv
    _cached_source uv generate-shell-completion zsh
    uv "$@"
  }
fi

# Docker completion — generate once, not on every shell start
if command -v docker &>/dev/null; then
  local _docker_comp="$HOME/.zsh/completions/_docker"
  if [[ ! -f "$_docker_comp" ]]; then
    mkdir -p "${_docker_comp:h}"
    docker completion zsh > "$_docker_comp"
  fi
  fpath=("${_docker_comp:h}" $fpath)
fi

if (( $+commands[aws_completer] )); then
  aws() {
    unfunction aws
    autoload -Uz bashcompinit && bashcompinit
    complete -C aws_completer aws
    aws "$@"
  }
fi

[ -s "${HOME}/.bun/_bun" ] && source "${HOME}/.bun/_bun"
