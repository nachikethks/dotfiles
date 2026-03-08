-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Flash jump + LSP actions
vim.keymap.set("n", "<leader>gd", function()
  require("flash").jump({
    action = function(match)
      vim.api.nvim_win_set_cursor(0, { match.pos[1], match.pos[2] })
      vim.lsp.buf.definition()
    end,
  })
end, { desc = "Flash → Go to Definition" })

vim.keymap.set("n", "<leader>gr", function()
  require("flash").jump({
    action = function(match)
      vim.api.nvim_win_set_cursor(0, { match.pos[1], match.pos[2] })
      Snacks.picker.lsp_references()
    end,
  })
end, { desc = "Flash → Go to References" })
