-- Persist hidden/ignored toggles across picker invocations (within a session)
local picker_state = { hidden = false, ignored = false }

local function with_persistent_toggles(opts)
  opts = opts or {}
  opts.hidden = picker_state.hidden
  opts.ignored = picker_state.ignored
  local user_on_close = opts.on_close
  opts.on_close = function(picker)
    picker_state.hidden = picker.opts.hidden or false
    picker_state.ignored = picker.opts.ignored or false
    if user_on_close then user_on_close(picker) end
  end
  return opts
end

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
  keys = {
    {
      "<leader>ff",
      function() Snacks.picker.files(with_persistent_toggles()) end,
      desc = "Find Files",
    },
    {
      "<leader><space>",
      function() Snacks.picker.smart(with_persistent_toggles()) end,
      desc = "Smart Find",
    },
    {
      "<leader>sg",
      function() Snacks.picker.grep(with_persistent_toggles()) end,
      desc = "Grep",
    },
    {
      "<leader>fg",
      function() Snacks.picker.git_files(with_persistent_toggles()) end,
      desc = "Find Files (git)",
    },
    {
      "<leader>sG",
      function() Snacks.picker.grep(with_persistent_toggles({ cwd = vim.fn.getcwd() })) end,
      desc = "Grep (cwd)",
    },
    {
      "<leader>fp",
      function()
        Snacks.picker.projects({
          confirm = function(picker, item)
            require("persistence").save()
            picker:close()
            vim.fn.chdir(item.file)
            require("persistence").load()
          end,
        })
      end,
      desc = "Projects (with session)",
    },
  },
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
