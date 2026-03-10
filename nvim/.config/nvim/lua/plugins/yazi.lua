return {
  "mikavilpas/yazi.nvim",
  event = "VeryLazy",
  dependencies = { "folke/snacks.nvim" },
  keys = {
    { "<leader>-", "<cmd>Yazi<cr>", desc = "Open yazi (current file)" },
    { "<leader>cw", "<cmd>Yazi cwd<cr>", desc = "Open yazi (cwd)" },
    { "<c-up>", "<cmd>Yazi toggle<cr>", desc = "Resume last yazi session" },
  },
  opts = {
    open_for_directories = false,
  },
}
