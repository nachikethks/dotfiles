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
local workspace_persist = require("config.lsp_workspace_persist")

local function project_root()
  if _G.LazyVim and LazyVim.root then
    return LazyVim.root()
  end
  return (uv.cwd and uv.cwd()) or vim.fn.getcwd()
end

local function collect_sibling_dirs(workspace_root)
  local parent = vim.fs.dirname(workspace_root)
  local found = {}
  if not parent or parent == workspace_root then
    return found, parent
  end

  for name, t in vim.fs.dir(parent) do
    if t == "directory" and not name:match("^%.") then
      local path = vim.fs.normalize(parent .. "/" .. name)
      if path ~= workspace_root then
        found[#found + 1] = path
      end
    end
  end

  table.sort(found)
  return found, parent
end

local function workspace_root_for_current_buffer(bufnr)
  local current_file = vim.api.nvim_buf_get_name(bufnr)
  local file_path = vim.fs.normalize(current_file ~= "" and current_file or project_root())

  local candidates = {}
  for _, folder in ipairs(vim.lsp.buf.list_workspace_folders()) do
    candidates[#candidates + 1] = vim.fs.normalize(folder)
  end
  candidates[#candidates + 1] = workspace_persist.current_root(bufnr)

  local best = nil
  for _, root in ipairs(candidates) do
    if root and file_path:sub(1, #root) == root and (not best or #root > #best) then
      best = root
    end
  end

  return best or workspace_persist.current_root(bufnr)
end

vim.keymap.set("n", "<leader>sA", function()
  local bufnr = vim.api.nvim_get_current_buf()
  local workspace_root = workspace_root_for_current_buffer(bufnr)
  local candidates, parent = collect_sibling_dirs(workspace_root)
  local existing = {}
  for _, folder in ipairs(vim.lsp.buf.list_workspace_folders()) do
    existing[vim.fs.normalize(folder)] = true
  end

  candidates = vim.tbl_filter(function(path)
    return not existing[path]
  end, candidates)

  if #candidates == 0 then
    local scope = parent or workspace_root
    vim.notify("No sibling directories available under " .. scope, vim.log.levels.WARN)
    return
  end

  vim.ui.select(candidates, {
    prompt = "Add sibling LSP workspace folder",
    format_item = function(item)
      return vim.fn.fnamemodify(item, ":~:.")
    end,
  }, function(choice)
    if not choice then
      return
    end
    vim.lsp.buf.add_workspace_folder(choice)
    workspace_persist.remember(bufnr, choice)
    vim.notify("Added LSP workspace folder: " .. vim.fn.fnamemodify(choice, ":~"))
  end)
end, { desc = "LSP Add Workspace Folder (Sibling)" })

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
    local bufnr = vim.api.nvim_get_current_buf()
    vim.lsp.buf.remove_workspace_folder(choice)
    workspace_persist.forget(bufnr, choice)
    vim.notify("Removed LSP workspace folder: " .. vim.fn.fnamemodify(choice, ":~"))
  end)
end, { desc = "LSP Remove Workspace Folder" })

local function floating_terminal(opts)
  opts = vim.tbl_deep_extend("force", {
    win = { position = "float" },
  }, opts or {})
  Snacks.terminal(nil, opts)
end

vim.keymap.set("n", "<leader>fT", function()
  floating_terminal()
end, { desc = "Terminal (cwd, Float)" })

vim.keymap.set("n", "<leader>ft", function()
  floating_terminal({ cwd = project_root() })
end, { desc = "Terminal (Root Dir, Float)" })
