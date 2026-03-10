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
        toggle_vertical = function(picker)
          local current = picker.layout.opts.layout
          local target = current.box == "vertical" and "default" or "vertical"
          local layout = Snacks.picker.config.layout({ layout = target })
          picker:set_layout(layout)
        end,
      },
      win = {
        input = {
          keys = {
            ["<c-l>"] = { "toggle_vertical", mode = { "i", "n" } },
          },
        },
      },
    },
  },
}
