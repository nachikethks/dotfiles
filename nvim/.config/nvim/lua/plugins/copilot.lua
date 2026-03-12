return {
  {
    "copilotlsp-nvim/copilot-lsp",
    init = function()
      local nes_ui = require("copilot-lsp.nes.ui")
      local orig_display_next_suggestion = nes_ui._display_next_suggestion
      nes_ui._display_next_suggestion = function(bufnr, ns_id, edits)
        if vim.api.nvim_get_mode().mode:sub(1, 1) == "i" then
          return false
        end
        return orig_display_next_suggestion(bufnr, ns_id, edits)
      end

      vim.g.copilot_nes_debounce = 200
      vim.lsp.enable("copilot_ls")

      vim.api.nvim_create_autocmd("InsertEnter", {
        callback = function()
          require("copilot-lsp.nes").clear()
        end,
        desc = "Hide Copilot NES in insert mode",
      })

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

      vim.keymap.set("n", "<tab>", accept_nes_or_fallback, { expr = true, desc = "Accept Copilot NES" })
      vim.keymap.set("n", "<Esc>", function()
        require("copilot-lsp.nes").clear()
      end, { desc = "Clear Copilot NES" })
      vim.keymap.set("i", "<Esc>", function()
        require("copilot-lsp.nes").clear()
        return "<Esc>"
      end, { expr = true, desc = "Clear Copilot NES and Esc" })
    end,
    opts = {
      nes = {
        move_count_threshold = 3,
      },
    },
  },
}
