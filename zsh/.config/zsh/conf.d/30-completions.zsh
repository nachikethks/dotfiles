# Cache dircolors output
if [[ ! -f ~/.zsh/cache/dircolors.zsh ]]; then
  mkdir -p ~/.zsh/cache
  dircolors -b > ~/.zsh/cache/dircolors.zsh
fi
source ~/.zsh/cache/dircolors.zsh

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}" 'ma=38;2;30;30;46;48;2;137;180;250' '=(#b)(*)( -- *)=38;2;127;132;156=38;2;137;180;250'
zstyle ':completion:*' menu select
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
