local layout_presets = {
  "default",
  "bottom",
  "top",
  "dropdown",
  "left",
  "right",
  "ivy",
  "ivy_split",
  "select",
  "sidebar",
  "telescope",
  "vertical",
  "vscode",
}

local function apply_preset(picker, preset)
  local ok, layout = pcall(Snacks.picker.config.layout, { layout = preset })
  if not ok then
    vim.notify("Snacks layout preset not found: " .. preset, vim.log.levels.WARN)
    return
  end

  picker._layout_preset = preset
  picker:set_layout(layout)
  vim.notify("Snacks picker layout: " .. preset, vim.log.levels.INFO)
end

return {
  "folke/snacks.nvim",
  opts = {
    explorer = {
      -- Don't hijack directory buffers on startup (keeps explorer closed by default)
      replace_netrw = false,
    },
    picker = {
      layouts = {
        vertical = {
          layout = {
            backdrop = false,
            width = 0.8,
            min_width = 80,
            height = 0.9,
            min_height = 30,
            box = "vertical",
            border = true,
            title = "{title} {live} {flags}",
            title_pos = "center",
            { win = "preview", title = "{preview}", height = 0.75, border = "bottom" },
            { win = "list", border = "none" },
            { win = "input", height = 1, border = "top" },
          },
        },
      },
      actions = {
        pick_layout_preset = function(picker)
          vim.ui.select(layout_presets, {
            prompt = "Snacks picker layout preset",
          }, function(choice)
            if choice then
              apply_preset(picker, choice)
            end
          end)
        end,
      },
      win = {
        input = {
          keys = {
            ["<a-l>"] = { "pick_layout_preset", mode = { "i", "n" } },
          },
        },
      },
    },
  },
}
