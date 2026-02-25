export ZDOTDIR="$HOME/.config/zsh"

# Optional: only source Cargo env if it exists
if [ -f "$HOME/.cargo/env" ]; then
  . "$HOME/.cargo/env"
fi
