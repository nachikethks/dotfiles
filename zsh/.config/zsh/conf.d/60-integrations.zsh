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

# Tool init scripts (starship prompt, zoxide cd, fzf fuzzy finder, navi cheatsheets)
_cached_source starship init zsh
_cached_source zoxide init --cmd cd zsh
_cached_source fzf --zsh
_cached_source navi widget zsh

# Lazy-load uv completions on first use — avoids slow init on every shell start
if (( $+commands[uv] )); then
  uv() {
    unfunction uv
    _cached_source uv generate-shell-completion zsh
    uv "$@"
  }
fi

# Docker completion — generate once and add to fpath, not on every shell start
if command -v docker &>/dev/null; then
  local _docker_comp="$HOME/.zsh/completions/_docker"
  if [[ ! -f "$_docker_comp" ]]; then
    mkdir -p "${_docker_comp:h}"
    docker completion zsh > "$_docker_comp"
  fi
  fpath=("${_docker_comp:h}" $fpath)
fi

# Lazy-load AWS CLI completions — needs bashcompinit since aws uses bash-style completion
if (( $+commands[aws_completer] )); then
  aws() {
    unfunction aws
    autoload -Uz bashcompinit && bashcompinit
    complete -C aws_completer aws
    aws "$@"
  }
fi

# Bun completions
[ -s "${HOME}/.bun/_bun" ] && source "${HOME}/.bun/_bun"

# Print resolved path on zoxide fuzzy jumps and cd -.
# Hooks into __zoxide_z by wrapping __zoxide_cd which zoxide calls for all directory changes.
__zoxide_cd() {
  # cd - prints the old dir by default, suppress it
  if [[ "$1" == "-" ]]; then
    \builtin cd -- "$@" > /dev/null && echo "󱞩 ${PWD/#$HOME/~}"
  else
    \builtin cd -- "$@"
  fi
}
# Print resolved path after zoxide fuzzy queries (not plain cd)
__zoxide_z() {
  __zoxide_doctor
  if [[ "$#" -eq 0 ]]; then
    __zoxide_cd ~
  elif [[ "$#" -eq 1 ]] && { [[ -d "$1" ]] || [[ "$1" = '-' ]] || [[ "$1" =~ ^[-+][0-9]+$ ]]; }; then
    __zoxide_cd "$1"
  elif [[ "$#" -eq 2 ]] && [[ "$1" = "--" ]]; then
    __zoxide_cd "$2"
  else
    \builtin local result
    result="$(\command zoxide query --exclude "$(__zoxide_pwd)" -- "$@")" \
      && __zoxide_cd "${result}" \
      && echo "󱞩 ${PWD/#$HOME/~}"
  fi
}
