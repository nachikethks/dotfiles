export PATH="$PATH:/opt/nvim-linux-x86_64/bin"
export PATH="$PATH:${HOME}/.local/bin"
export PATH="$PATH:${HOME}/.fzf/bin"
export PATH="$PATH:/usr/local/go/bin"
export PATH="$PATH:${HOME}/.cargo/bin"

export EDITOR="nvim"

export STARSHIP_CONFIG=$HOME/.config/starship/starship.toml

export PNPM_HOME="${HOME}/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

