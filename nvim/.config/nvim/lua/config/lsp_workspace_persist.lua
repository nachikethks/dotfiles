local M = {}

local uv = vim.uv or vim.loop
local state_file = vim.fn.stdpath("state") .. "/lsp-workspaces.json"

local function normalize(path)
  if not path or path == "" then
    return nil
  end
  return vim.fs.normalize(path)
end

local function dedupe_sorted(paths)
  local seen = {}
  local out = {}
  for _, path in ipairs(paths or {}) do
    local n = normalize(path)
    if n and not seen[n] then
      seen[n] = true
      out[#out + 1] = n
    end
  end
  table.sort(out)
  return out
end

local function read_db()
  if vim.fn.filereadable(state_file) == 0 then
    return {}
  end

  local lines = vim.fn.readfile(state_file)
  if #lines == 0 then
    return {}
  end

  local ok, data = pcall(vim.json.decode, table.concat(lines, "\n"))
  if not ok or type(data) ~= "table" then
    return {}
  end
  return data
end

local function write_db(data)
  local dir = vim.fs.dirname(state_file)
  if dir and dir ~= "" then
    vim.fn.mkdir(dir, "p")
  end

  local ok, encoded = pcall(vim.json.encode, data)
  if not ok then
    return false
  end

  vim.fn.writefile({ encoded }, state_file)
  return true
end

function M.current_root(bufnr)
  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  for _, client in ipairs(clients) do
    local root = client.config and client.config.root_dir
    if root and root ~= "" then
      return normalize(root)
    end
  end

  local folders = vim.lsp.buf.list_workspace_folders()
  if #folders > 0 then
    return normalize(folders[1])
  end

  return normalize((uv.cwd and uv.cwd()) or vim.fn.getcwd())
end

function M.list_saved(bufnr)
  local root = M.current_root(bufnr)
  if not root then
    return {}, nil
  end

  local db = read_db()
  return dedupe_sorted(db[root] or {}), root
end

function M.remember(bufnr, folder)
  local root = M.current_root(bufnr)
  local folder_n = normalize(folder)
  if not root or not folder_n or folder_n == root then
    return
  end

  local db = read_db()
  local list = db[root] or {}
  list[#list + 1] = folder_n
  db[root] = dedupe_sorted(list)
  write_db(db)
end

function M.forget(bufnr, folder)
  local root = M.current_root(bufnr)
  local folder_n = normalize(folder)
  if not root or not folder_n then
    return
  end

  local db = read_db()
  local list = db[root] or {}
  local next_list = {}
  for _, item in ipairs(list) do
    if normalize(item) ~= folder_n then
      next_list[#next_list + 1] = item
    end
  end

  next_list = dedupe_sorted(next_list)
  if #next_list == 0 then
    db[root] = nil
  else
    db[root] = next_list
  end
  write_db(db)
end

function M.restore(bufnr)
  local root = M.current_root(bufnr)
  if not root then
    return
  end

  local saved, _ = M.list_saved(bufnr)
  if #saved == 0 then
    return
  end

  vim.api.nvim_buf_call(bufnr, function()
    local existing = {}
    for _, folder in ipairs(vim.lsp.buf.list_workspace_folders()) do
      existing[normalize(folder)] = true
    end

    for _, folder in ipairs(saved) do
      if folder ~= root and not existing[folder] then
        local stat = uv.fs_stat(folder)
        if stat and stat.type == "directory" then
          vim.lsp.buf.add_workspace_folder(folder)
          existing[folder] = true
        end
      end
    end
  end)
end

return M
