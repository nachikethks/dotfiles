return {
  {
    "zbirenbaum/copilot.lua",
    opts = {
      suggestion = {
        keymap = {
          accept = "<S-Tab>",
        },
      },
    },
  },
  {
    "copilotlsp-nvim/copilot-lsp",
    init = function()
      vim.g.copilot_nes_debounce = 500
      vim.lsp.enable("copilot_ls")

      -- Accept NES suggestion in normal mode with Tab
      vim.keymap.set("n", "<tab>", function()
        local nes = require("copilot-lsp.nes")
        local state = vim.b[vim.api.nvim_get_current_buf()].nes_state
        if state then
          local _ = nes.walk_cursor_start_edit()
            or (nes.apply_pending_nes() and nes.walk_cursor_end_edit())
          return nil
        else
          return "<C-i>"
        end
      end, { expr = true, desc = "Accept Copilot NES" })
    end,
    opts = {
      nes = {
        move_count_threshold = 3,
      },
    },
  },
}
