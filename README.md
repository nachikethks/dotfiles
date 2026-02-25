# dotfiles

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Packages

| Package    | Stows to               | Dependencies                        |
|------------|------------------------|-------------------------------------|
| `zsh`      | `~/.zshenv`, `~/.config/zsh/` | `zsh`, `zinit` (auto-installed), `starship`, `zoxide`, `fzf` (auto-installed), `eza`, `bat`, `uv` |
| `git`      | `~/.config/git/`       | `git`, `delta`                |
| `starship` | `~/.config/starship/`  | `starship`                          |
| `kitty`    | `~/.config/kitty/`     | `kitty`                             |
| `zellij`   | `~/.config/zellij/`    | `zellij`                            |
| `nvim`     | `~/.config/nvim/`      | `neovim >= 0.9`, `git`              |

> **Note:** `nvim` is not stowed here — it's managed as a separate LazyVim repo at `~/.config/nvim`.

## Install on a new system

### 1. Install dependencies

```bash
# Core tools
sudo apt install zsh git stow

# Shell tools
curl -sS https://starship.rs/install.sh | sh          # starship
curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash  # zoxide
curl -LsSf https://astral.sh/uv/install.sh | sh       # uv

# Optional (used in aliases)
sudo apt install xh btop
```

### 2. Clone and stow

```bash
git clone <your-repo-url> ~/dotfiles
cd ~/dotfiles
stow */
```

> `zinit` and `fzf` are auto-installed on first shell launch.

### 3. Change shell

```bash
chsh -s $(which zsh)
```

### 4. Secrets

Create `~/.config/zsh/conf.d/99-secrets.zsh` for machine-local secrets (tokens, private aliases). This file is gitignored.

```zsh
# Example
export GITHUB_TOKEN="..."
export AWS_PROFILE="..."
```

## Structure

```
~/dotfiles/
├── zsh/
│   ├── .zshenv                  # sets ZDOTDIR
│   └── .config/zsh/
│       ├── .zshrc               # sources conf.d/*
│       └── conf.d/
│           ├── 00-env.zsh
│           ├── 10-history.zsh
│           ├── 20-plugins.zsh   # zinit plugins
│           ├── 30-completions.zsh
│           ├── 40-keybindings.zsh
│           ├── 50-aliases.zsh
│           ├── 60-prompt.zsh    # starship
│           └── 70-integrations.zsh  # zoxide, fzf, uv
├── git/.config/git/
│   ├── config
│   └── ignore
├── starship/.config/starship/starship.toml
├── kitty/.config/kitty/
│   ├── kitty.conf
│   └── ssh.conf
└── zellij/.config/zellij/config.kdl
```
