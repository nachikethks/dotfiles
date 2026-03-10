return {
  { "mason-org/mason-lspconfig.nvim", opts = { ensure_installed = { "ruff" } } },
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      if not vim.tbl_contains(opts.ensure_installed, "copilot-language-server") then
        table.insert(opts.ensure_installed, "copilot-language-server")
      end
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = { enabled = false },
      },
    },
  },
}
