ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "${ZINIT_HOME}/zinit.zsh"

# Load immediately (must be before compinit)
zinit light zpm-zsh/clipboard

# Turbo mode for faster loading
zinit wait lucid for \
    atinit"zicompinit; zicdreplay" \
        zdharma-continuum/fast-syntax-highlighting \
    atload"_zsh_autosuggest_start" \
        zsh-users/zsh-autosuggestions \
    blockf atpull'zinit creinstall -q .' \
        zsh-users/zsh-completions \
    Aloxaf/fzf-tab \
    OMZP::git \
    OMZP::sudo \
    OMZP::cp \
    OMZP::colored-man-pages

zstyle ':omz:plugins:eza' icons yes
zinit ice from"gh-r" as"program" mv"eza* -> eza" pick"eza"
zinit load eza-community/eza
zinit snippet OMZP::eza

zinit ice from"gh-r" as"program" mv"bat* -> bat" pick"bat"
zinit load sharkdp/bat
