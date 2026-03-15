# dotfiles

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Packages

| Package    | Stows to               | Dependencies                        |
|------------|------------------------|-------------------------------------|
| `zsh`      | `~/.zshenv`, `~/.config/zsh/` | `zsh`, `zinit` (auto-installed), `starship`, `zoxide`, `fzf` (auto-installed), `eza`, `bat`, `uv` |
| `git`      | `~/.config/git/`       | `git`, `delta`                      |
| `lazygit`  | `~/.config/lazygit/`   | `lazygit`                           |
| `starship` | `~/.config/starship/`  | `starship`, `noto-fonts-emoji`, `ttf-jetbrains-mono-nerd`,                           |
| `kitty`    | `~/.config/kitty/`     | `kitty`                             |
| `tmux`     | `~/.config/tmux/`      | `tmux`                              |
| `zellij`   | `~/.config/zellij/`    | `zellij`                            |
| `nvim`     | `~/.config/nvim/`      | `neovim >= 0.11`, `git`, `rg`, `fd`, `lazygit`, `fzf`, `tree-sitter`, `node`, `luarocks`, `python3`/`pynvim`, `xclip`, `cargo`, `clang`, `llvm`, `unzip` |
| `elephant` | `~/.config/elephant/`  | `elephant`                          |
| `keyd`     | `/etc/keyd/` (system)  | `keyd` (AUR/pacman), `systemctl enable --now keyd` |
| `walker`   | `~/.config/walker/`    | `walker-bin`, `elephant`, `elephant-providerlist`, `elephant-desktopapplications`, `elephant-files`, `elephant-runner`, `elephant-calc`, `elephant-archlinuxpkgs`, `elephant-bluetooth`, `elephant-clipboard`, `elephant-symbols`, `elephant-todo`, `elephant-unicode`, `elephant-websearch` (`elephant` must be running for providers like `calc`, `clipboard`, `symbols`, `unicode`, `archlinuxpkgs`, `todo`, and `bluetooth` to appear) |
| `zathura`  | `~/.config/zathura/`   | `zathura`                           |

## Dependencies

### System tools

| Tool | Purpose | Install |
|------|---------|---------|
| `zsh` | Shell | `sudo apt install zsh` |
| `git` | Version control | `sudo apt install git` |
| `stow` | Dotfiles management | `sudo apt install stow` |
| `rg` (ripgrep) | Fast grep, used by nvim/lazyvim | `sudo apt install ripgrep` |
| `fd` | Fast find, used by nvim/lazyvim | `sudo apt install fd-find` |
| `fzf` | Fuzzy finder | auto-installed by zinit |
| `lazygit` | TUI git client | [releases](https://github.com/jesseduffield/lazygit/releases) |
| `tree-sitter` | Treesitter CLI | `cargo install --locked tree-sitter-cli` or `npm i -g tree-sitter-cli` |
| `delta` | Git diff pager | `sudo apt install git-delta` |
| `eza` | Modern `ls` | `sudo apt install eza` |
| `bat` | Modern `cat` | `sudo apt install bat` |
| `xclip` | Clipboard support in nvim | `sudo apt install xclip` |
| `xh` | Modern HTTP client | `cargo install xh` |
| `btop` | System monitor | `sudo apt install btop` |
| `zoxide` | Smarter `cd` | `curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh \| sh` |
| `starship` | Shell prompt | `curl -sS https://starship.rs/install.sh \| sh` |
| `uv` | Python package manager | `curl -LsSf https://astral.sh/uv/install.sh \| sh` |
| `sqlite3` | SQLite, used by snacks.nvim picker | `sudo apt install sqlite3` |
| `gio` | File trash support in nvim explorer | part of `libglib2.0-bin` |

### Node.js / npm

| Tool | Purpose | Install |
|------|---------|---------|
| `node` (v22+) | Node.js provider for nvim | via `nvm` or `fnm` |
| `neovim` npm package | Nvim node provider | `npm i -g neovim` |
| `mmdc` | Mermaid diagram rendering | `npm i -g @mermaid-js/mermaid-cli` |

### Python

| Tool | Purpose | Install |
|------|---------|---------|
| `python3` | Python provider for nvim | `sudo apt install python3` |
| `pynvim` | Nvim python provider | `pip install pynvim` |

### Lua

| Tool | Purpose | Install |
|------|---------|---------|
| `luarocks` | Lua package manager (lazy.nvim) | `sudo apt install luarocks` |
| `lua5.1` | Lua runtime for luarocks | `sudo apt install lua5.1` |

### Optional (snacks.nvim image rendering)

| Tool | Purpose | Install |
|------|---------|---------|
| `kitty` or `ghostty` | Terminal with graphics protocol | [kitty](https://sw.kovidgoyal.net/kitty/) / [ghostty](https://ghostty.org/) |
| `convert` (ImageMagick) | Image processing | `sudo apt install imagemagick` |
| `gs` (Ghostscript) | PDF rendering | `sudo apt install ghostscript` |
| `tectonic` | LaTeX rendering | `cargo install tectonic` |

## Install on a new system

### 1. Install dependencies

```bash
# Core tools
sudo apt install zsh git stow ripgrep fd-find luarocks lua5.1 sqlite3 xclip imagemagick ghostscript btop libglib2.0-bin

# Shell / prompt tools
curl -sS https://starship.rs/install.sh | sh
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
curl -LsSf https://astral.sh/uv/install.sh | sh

# Modern CLI replacements
sudo apt install eza bat

# Git tools
# Install delta: https://github.com/dandavison/delta/releases
# Install lazygit: https://github.com/jesseduffield/lazygit/releases

# Node.js (via fnm or nvm), then:
npm i -g neovim @mermaid-js/mermaid-cli tree-sitter-cli

# Python provider
pip install pynvim

# Optional (used in aliases)
sudo apt install xh
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

### 4. Walker runtime

Walker uses Elephant providers at runtime. Installing `elephant-calc` is not enough on its own; the `elephant` backend must also be running or providers like `calc` will not show up.

```bash
elephant service enable
```

Verify the providers are available with:

```bash
elephant listproviders
```

### 5. Secrets

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
│           ├── 70-integrations.zsh  # zoxide, fzf, uv
│           └── 99-secrets.zsh   # gitignored, machine-local secrets
├── git/.config/git/
│   ├── config
│   └── ignore
├── lazygit/.config/lazygit/
│   └── config.yml
├── starship/.config/starship/starship.toml
├── kitty/.config/kitty/
│   ├── kitty.conf
│   ├── fonts.conf
│   ├── colors.conf
│   ├── window.conf
│   ├── keybindings.conf
│   ├── advanced.conf
│   ├── scrollback.conf
│   └── kitty-scrollback.conf
├── tmux/.config/tmux/tmux.conf
├── zellij/.config/zellij/config.kdl
├── elephant/.config/elephant/
│   └── elephant.toml
├── nvim/.config/nvim/
│   ├── init.lua
│   ├── lazyvim.json
│   └── lazy-lock.json
├── walker/.config/walker/
│   ├── config.toml
│   └── themes/catppuccin-mocha/style.css
├── zathura/.config/zathura/
│   └── zathurarc
└── keyd/etc/keyd/
    └── default.conf         # CapsLock = Esc (tap) / Ctrl (hold)
```

> **Note:** `keyd` stows to `/etc/keyd/` (a system path). Use `sudo stow --target=/ keyd` instead of the regular `stow */`.
