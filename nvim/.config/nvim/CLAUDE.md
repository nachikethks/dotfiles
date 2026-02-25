# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal [LazyVim](https://lazyvim.github.io) Neovim configuration. LazyVim provides the base framework; this repo contains only the customizations layered on top.

## Code Style

Lua formatting is enforced by `stylua` (configured in `stylua.toml`):

- Indent: 2 spaces
- Column width: 120

Format a file: `stylua lua/plugins/example.lua`
Format all Lua files: `stylua lua/`

## Architecture

LazyVim loads files in a specific order:

1. `init.lua` — bootstraps lazy.nvim, then delegates to `lua/config/lazy.lua`
2. `lua/config/options.lua` — loaded before plugins start
3. `lua/config/lazy.lua` — sets up lazy.nvim, imports LazyVim's own plugins, then imports all files in `lua/plugins/`
4. `lua/config/keymaps.lua` and `lua/config/autocmds.lua` — loaded on the `VeryLazy` event

### Key customizations vs. LazyVim defaults

- **`lua/config/options.lua`**: Autoformat is disabled globally (`vim.g.autoformat = false`); snacks animations are disabled.
- **`lua/config/autocmds.lua`**: Auto-save is active — files are silently written on `InsertLeave` and `TextChanged`.
- **`lua/plugins/blink.lua`**: Completion navigation remapped to `<C-j>`/`<C-k>`, `<Tab>` accepts, `<CR>` is disabled.
- **`lua/plugins/theme.lua`**: Colorscheme is `catppuccin-mocha`.
- **`lua/plugins/kitty-scrollback.lua`**: Integration with the Kitty terminal's scrollback buffer.
- **`lazyvim.json`**: Tracks enabled LazyVim extras — currently `supermaven` (AI completion) and `yanky` (clipboard management).

### Adding/modifying plugins

Create or edit a file under `lua/plugins/`. Each file returns a table (or list of tables) in lazy.nvim spec format. To override a LazyVim built-in plugin, use the same plugin name/repo with `opts` to merge changes or `enabled = false` to disable it.

The file `lua/plugins/example.lua` is a reference template (disabled by `if true then return {} end` at the top).

### Managing LazyVim extras

LazyVim extras (e.g., language packs) are tracked in `lazyvim.json`. Enable/disable them via `:LazyExtras` inside Neovim rather than editing this file manually.

### Lockfile

`lazy-lock.json` pins plugin versions. Commit it to reproduce a known-good state. Update with `:Lazy update` inside Neovim.
