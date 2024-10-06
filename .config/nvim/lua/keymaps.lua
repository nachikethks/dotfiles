vim.api.nvim_set_keymap('n', '<Esc>', '<CR>:noh<CR>', { silent = true })

vim.api.nvim_set_keymap('n', '<C-a>', '<cmd> %y+ <cr>', { silent = true, desc = "Copy entire file" })


-- Toggle line wrap
vim.api.nvim_set_keymap('n', '<leader>wr', ':set wrap!<CR>', { noremap = true, silent = true, desc = "Toggle Line Wrap" })

-- Buffer Navigation
vim.keymap.set("n", "<Tab>", ":BufferLineCycleNext<CR>", { desc = "Next buffer", silent = true })
vim.keymap.set("n", "<S-Tab>", ":BufferLineCyclePrev<CR>", { desc = "Prev buffer", silent = true })
vim.keymap.set("n", "<S-right>", ":BufferLineMoveNext<CR>", { desc = "Shift Buffer Right", silent = true })
vim.keymap.set("n", "<S-left>", ":BufferLineMovePrev<CR>", { desc = "Shift Buffer Left", silent = true })
vim.keymap.set('n', '<leader>bn', '<cmd> enew <cr>', { silent = true, desc = "New buffer" })
vim.keymap.set("n", "<leader>bb", ":e #<CR>", { desc = "Previous buffer", silent = true })
vim.keymap.set('n', '<leader>bx', ":bdelete<CR>", { desc = "Close buffer", silent = true })

-- Move selected text UP and DOWN
vim.api.nvim_set_keymap("v", "J", ":m '>+1<CR>gv=gv", { silent = true })
vim.api.nvim_set_keymap("v", "K", ":m '<-2<CR>gv=gv", { silent = true })

-- Key mappings for moving between splits
vim.api.nvim_set_keymap('n', '<C-h>', '<C-w>h', { noremap = true, silent = true }) -- Move to the left split
vim.api.nvim_set_keymap('n', '<C-j>', '<C-w>j', { noremap = true, silent = true }) -- Move to the below split
vim.api.nvim_set_keymap('n', '<C-k>', '<C-w>k', { noremap = true, silent = true }) -- Move to the above split
vim.api.nvim_set_keymap('n', '<C-l>', '<C-w>l', { noremap = true, silent = true }) -- Move to the right split

-- Up and Down seamlessly on a wrapped line
vim.api.nvim_set_keymap("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.api.nvim_set_keymap("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Better HJKL mappings
vim.api.nvim_set_keymap('n', 'H', '^', { noremap = true, silent = true }) -- Move to the beginning of the line
vim.api.nvim_set_keymap('n', 'L', '$', { noremap = true, silent = true }) -- Move to the end of the line
vim.api.nvim_set_keymap('n', 'J', '}', { noremap = true, silent = true }) -- Move to the next paragraph
vim.api.nvim_set_keymap('n', 'K', '{', { noremap = true, silent = true }) -- Move to the previous paragraph

-- Better escape in insert mode
vim.api.nvim_set_keymap('i', 'jk', '<Esc>', { noremap = true, silent = true }) -- Use 'jk' to escape insert mode

-- Keep text selected when pressing Shift + < or Shift + >
vim.api.nvim_set_keymap('v', '>', '>gv', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<', '<gv', { noremap = true, silent = true })

-- Keep the cursor centered while scrolling
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Keep the cursor centered while /search
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Select and paste without loosing copied text in register
vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Paste without losing copied text" })

-- Delete text to void register
vim.keymap.set("v", "<leader>d", [["_d]], {desc = "Delete to void register"})

-- Build and execute
local lang_maps = {
    cpp = { build = "g++ % -o %:r", exec = "./%:r" },
    python = { exec = "python %" },
    java = { build = "javac %", exec = "java %" },
}
for lang, data in pairs(lang_maps) do
    if data.build ~= nil then
        vim.api.nvim_create_autocmd(
            "FileType",
            { command = "nnoremap <leader>bu :!" .. data.build .. "<CR>", pattern = lang }
        )
    end
    vim.api.nvim_create_autocmd(
        "FileType",
        { command = "nnoremap <leader>ex :split<CR>:ter " .. data.exec .. "<CR>", pattern = lang }
    )
end

-- Toggle Relative Line Number in Insert and Visual Mode
vim.api.nvim_create_autocmd("InsertEnter", { command = "set norelativenumber", pattern = "*" })
vim.api.nvim_create_autocmd("InsertLeave", { command = "set relativenumber", pattern = "*" })

-- Window resizing
vim.keymap.set("n", "<leader>sv", ":vsplit<CR>", { desc = "Split Window Verically" })
vim.keymap.set("n", "<leader>sh", ":split<CR>", { desc = "Split Window Horizontally" })
vim.keymap.set("n", "<leader>sx", ":q<CR>", { desc = "Close split" })
vim.keymap.set("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
vim.keymap.set("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })
