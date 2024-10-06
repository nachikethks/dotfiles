local builtin = require("telescope.builtin")
local actions = require("telescope.actions")
return {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        "nvim-tree/nvim-web-devicons",
    },
    opts = {
        defaults = {
            file_ignore_patterns = {
                "^.git/",
                "^node_modules/",
                "^target/",
                "^build/",
                "^dist/",
                "^.cache/",
                "^vendor/",
                "^__pycache__",
                "^venv/",
                "^.venv/"
            },
            layout_config = {
                horizontal = { preview_width = 0.55 },
                width = 0.9
            },
            path_display = { "smart" },
            mappings = {
                i = {
                    ["<C-k>"] = actions.move_selection_previous, -- move to prev result
                    ["<C-j>"] = actions.move_selection_next,     -- move to next result
                },
            },
        },
        extensions_list = { "term" },
        pickers = {
            find_files = {
                no_ignore = true,
            },
        }
    },
    keys = {
        { "<leader>ff", builtin.find_files,                                                        desc = "Telescope Find Files" },
        { "<leader>ft", builtin.live_grep,                                                         desc = "Telescope Live Grep" },
        { "<leader>fg", builtin.git_files,                                                         desc = "Telescope Find Git Files" },
        { "<leader>fh", builtin.help_tags,                                                         desc = "Telescope Help" },
        { "<leader>fj", builtin.jumplist,                                                          desc = "Jumplist" },
        { "<leader>fk", builtin.keymaps,                                                           desc = "Key Maps" },
        { '<leader>fr', builtin.resume,                                                            desc = "Resume Telescope" },
        { '<leader>fc', builtin.commands,                                                          desc = "List all Vim Autocommands" },
        { '<leader>fo', builtin.vim_options,                                                       desc = "List Vim Options" },
        { "<leader>fb", function() builtin.buffers({ sort_mru = true, sort_lastused = true }) end, desc = "Telescope Buffers" },
    }
}
