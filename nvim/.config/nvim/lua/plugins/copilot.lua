return {
  {
    "copilotlsp-nvim/copilot-lsp",
    dependencies = { "fang2hou/blink-copilot" },
    init = function()
      local nes_ui = require("copilot-lsp.nes.ui")
      local orig_display_next_suggestion = nes_ui._display_next_suggestion
      nes_ui._display_next_suggestion = function(bufnr, ns_id, edits)
        if vim.api.nvim_get_mode().mode:sub(1, 1) == "i" then
          return false
        end
        local result = orig_display_next_suggestion(bufnr, ns_id, edits)
        if result and edits and #edits > 1 then
          for i = 2, math.min(3, #edits) do
            local preview = nes_ui._calculate_preview(bufnr, edits[i])
            nes_ui._display_preview(bufnr, ns_id, preview)
          end
        end
        return result
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

      -- Use VeryLazy + vim.schedule to ensure these run after LazyVim's default <Esc> mapping
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        once = true,
        callback = function()
          vim.schedule(function()
            vim.keymap.set("n", "<Esc>", function()
              require("copilot-lsp.nes").clear()
              vim.cmd("nohlsearch")
            end, { desc = "Clear Copilot NES" })
            vim.keymap.set("i", "<Esc>", function()
              require("copilot-lsp.nes").clear()
              return "<Esc>"
            end, { expr = true, desc = "Clear Copilot NES and Esc" })
          end)
        end,
      })
    end,
    opts = {
      nes = {
        move_count_threshold = 3,
      },
    },
  },
}
