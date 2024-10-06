return {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    opts = {
        disable_netrw = true,
        hijack_cursor = true,
        view = {
            width = 35,
        },
        renderer = {
            root_folder_label = false,
            highlight_git = true,
            indent_markers = {
                enable = true,
            }
        },
        actions = {
            open_file = {
                window_picker = {
                    enable = false,
                },
            },
        },
        filters = {
            custom = { ".DS_Store" },
        },
        git = {
            ignore = false,
        }
    },
    config = function(_, opts)
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1
        vim.opt.termguicolors = true

        vim.cmd([[ highlight NvimTreeFolderArrowClosed guifg=#3FC5FF ]])
        vim.cmd([[ highlight NvimTreeFolderArrowOpen guifg=#3FC5FF ]])

        require("nvim-tree").setup(opts)

        -- Key mappings for nvim-tree
        vim.keymap.set("n", "<leader>ee", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
        vim.keymap.set("n", "<leader>ef", "<cmd>NvimTreeFindFile<CR>", { desc = "Toggle file explorer on current file" })
        vim.keymap.set("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>", { desc = "Collapse file explorer" })
        vim.keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh file explorer" })
    end
}
