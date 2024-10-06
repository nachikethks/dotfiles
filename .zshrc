export PATH="$PATH:/opt/nvim-linux64/bin"
export PATH="$PATH:${HOME}/.local/bin"
export PATH="$PATH:${HOME}/.fzf/bin"

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Self update
# zinit self-update

# Plugin update
# zinit update --parallel

eval "$(starship init zsh)"

# # Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab
zinit light zpm-zsh/clipboard

# Add in snippets
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::command-not-found
zinit snippet OMZP::cp
zinit snippet OMZP::colored-man-pages

# Asynchronously load compinit
() {
    nohup zsh -c 'autoload -Uz compinit && compinit' &>/dev/null &
} &
clear

# autoload -Uz compinit && compinit
zinit cdreplay -q

# Vim mode
bindkey -v

bindkey '^r' history-incremental-search-backward
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# History
HISTSIZE=10000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --icons=always --color=always $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza -1 --icons=always --color=always $realpath'
zstyle ':completion:*:git-checkout:*' sort false
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':fzf-tab:*' fzf-flags --color=fg:1,fg+:2
zstyle ':fzf-tab:*' switch-group '<' '>'

# Aliases
alias ls='ls --color'
alias vim='nvim'

# Shell integrations
eval "$(zoxide init --cmd cd zsh)"
if [ !  -f ~/.fzf.zsh ]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install
fi
source <(fzf --zsh)
