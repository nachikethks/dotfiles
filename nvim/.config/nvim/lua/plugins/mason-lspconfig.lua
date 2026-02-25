return {
  { "mason-org/mason-lspconfig.nvim", opts = { ensure_installed = { "ruff" } } },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = { enabled = false },
      },
    },
  },
}
