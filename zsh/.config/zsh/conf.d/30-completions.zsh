# Cache dircolors output
if [[ ! -f ~/.zsh/cache/dircolors.zsh ]]; then
  mkdir -p ~/.zsh/cache
  dircolors -b > ~/.zsh/cache/dircolors.zsh
fi
source ~/.zsh/cache/dircolors.zsh

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu select
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
