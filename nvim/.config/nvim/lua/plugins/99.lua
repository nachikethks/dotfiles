return {
  {
    "ThePrimeagen/99",
    event = "VeryLazy",
    dependencies = { { "saghen/blink.compat", version = "2.*" }, },
    keys = {
      { "<leader>9v", function() require("99").visual({}) end, mode = "v", desc = "99: Process visual selection", },
      { "<leader>9x", function() require("99").stop_all_requests() end, desc = "99: Cancel all requests", },
      { "<leader>9s", function() require("99").search({}) end, desc = "99: Search", },
      {
        "<leader>9m",
        function()
          local pickers = require("99.extensions.pickers")
          pickers.get_models(nil, function(models, current)
            vim.ui.select(models, {
              prompt = "99: Select model",
              format_item = function(item)
                if item == current then
                  return item .. " (current)"
                end
                return item
              end,
            }, function(choice)
              if choice then
                pickers.on_model_selected(choice)
              end
            end)
          end)
        end,
        desc = "99: Select model",
      },
    },
    opts = function()
      return {
        provider = require("99.providers").ClaudeCodeProvider,
        completion = { source = "blink" },
      }
    end,
  },
}
