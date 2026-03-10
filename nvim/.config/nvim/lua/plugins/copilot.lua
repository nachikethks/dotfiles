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
      local function accept_nes_or_fallback()
        local nes = require("copilot-lsp.nes")
        local state = vim.b[vim.api.nvim_get_current_buf()].nes_state
        if state then
          local _ = nes.walk_cursor_start_edit()
            or (nes.apply_pending_nes() and nes.walk_cursor_end_edit())
          return nil
        else
          return "<C-i>"
        end
      end

      local function accept_nes_insert_or_fallback()
        local ok, suggestion = pcall(require, "copilot.suggestion")
        if ok and suggestion.is_visible() then
          suggestion.accept()
          return ""
        end

        local nes = require("copilot-lsp.nes")
        local state = vim.b[vim.api.nvim_get_current_buf()].nes_state
        if state then
          local _ = nes.walk_cursor_start_edit()
            or (nes.apply_pending_nes() and nes.walk_cursor_end_edit())
          return ""
        end

        return "<S-Tab>"
      end

      vim.keymap.set("n", "<tab>", accept_nes_or_fallback, { expr = true, desc = "Accept Copilot NES" })
      vim.keymap.set("i", "<S-Tab>", accept_nes_insert_or_fallback, { expr = true, desc = "Accept Copilot NES" })
    end,
    opts = {
      nes = {
        move_count_threshold = 3,
      },
    },
  },
}
