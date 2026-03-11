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

local uv = vim.uv or vim.loop

local function project_root()
  if _G.LazyVim and LazyVim.root then
    return LazyVim.root()
  end
  return (uv.cwd and uv.cwd()) or vim.fn.getcwd()
end

local function is_service_dir(path)
  local markers = {
    "package.json",
    "go.mod",
    "pyproject.toml",
    "Cargo.toml",
    "pom.xml",
    "build.gradle",
    ".git",
  }
  for _, marker in ipairs(markers) do
    if uv.fs_stat(path .. "/" .. marker) then
      return true
    end
  end
  return false
end

local function collect_service_dirs(base, max_depth)
  local skip = {
    [".git"] = true,
    ["node_modules"] = true,
    [".next"] = true,
    ["dist"] = true,
    ["build"] = true,
    [".venv"] = true,
    ["venv"] = true,
    ["target"] = true,
  }
  local seen = {}
  local found = {}

  local function walk(dir, depth)
    if depth > max_depth then
      return
    end
    for name, t in vim.fs.dir(dir) do
      if t == "directory" and not skip[name] and not name:match("^%.") then
        local path = vim.fs.normalize(dir .. "/" .. name)
        if not seen[path] then
          seen[path] = true
          if is_service_dir(path) then
            found[#found + 1] = path
          end
          walk(path, depth + 1)
        end
      end
    end
  end

  walk(vim.fs.normalize(base), 1)
  table.sort(found)
  return found
end

vim.keymap.set("n", "<leader>sA", function()
  local base = project_root()
  local candidates = collect_service_dirs(base, 2)
  if #candidates == 0 then
    vim.notify("No service directories found under " .. base, vim.log.levels.WARN)
    return
  end

  vim.ui.select(candidates, {
    prompt = "Add LSP workspace folder",
    format_item = function(item)
      return vim.fn.fnamemodify(item, ":~:.")
    end,
  }, function(choice)
    if not choice then
      return
    end
    vim.lsp.buf.add_workspace_folder(choice)
    vim.notify("Added LSP workspace folder: " .. vim.fn.fnamemodify(choice, ":~"))
  end)
end, { desc = "LSP Add Workspace Folder (Service)" })

vim.keymap.set("n", "<leader>sL", function()
  local folders = vim.lsp.buf.list_workspace_folders()
  if #folders == 0 then
    vim.notify("No LSP workspace folders for current client/buffer", vim.log.levels.INFO)
    return
  end
  vim.ui.select(folders, {
    prompt = "LSP workspace folders",
    format_item = function(item)
      return vim.fn.fnamemodify(item, ":~:.")
    end,
  }, function() end)
end, { desc = "LSP Workspace Folders" })

vim.keymap.set("n", "<leader>sX", function()
  local folders = vim.lsp.buf.list_workspace_folders()
  if #folders == 0 then
    vim.notify("No LSP workspace folders to remove", vim.log.levels.INFO)
    return
  end

  vim.ui.select(folders, {
    prompt = "Remove LSP workspace folder",
    format_item = function(item)
      return vim.fn.fnamemodify(item, ":~:.")
    end,
  }, function(choice)
    if not choice then
      return
    end
    vim.lsp.buf.remove_workspace_folder(choice)
    vim.notify("Removed LSP workspace folder: " .. vim.fn.fnamemodify(choice, ":~"))
  end)
end, { desc = "LSP Remove Workspace Folder" })
