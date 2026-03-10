-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- vim.opt.runtimepath:append(vim.fn.stdpath("data") .. "/site")
vim.g.snacks_animate = false
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.g.autoformat = false
vim.g.ai_cmp = false
vim.opt.showtabline = 0
vim.opt.listchars = { trail = "·", extends = "❯", precedes = "❮", nbsp = "⚑" }
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
