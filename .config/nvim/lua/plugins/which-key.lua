return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
        "echasnovski/mini.icons",
    },
    opts = {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
    },
    keys = {
        {
            "<leader>?",
            function() require("which-key").show({ global = true }) end,
            desc = "Buffer Local Keymaps (which-key)",
        },
    },
    config = function (_, opts)
        local wk = require("which-key")
        wk.setup(opts)

        wk.add({
            { "<leader>f", group = "Telescope" }, -- group
            { "<leader>x", group = "Trouble", icon = "󰖷" }, -- group
            { "<leader>e", group = "NvimTree", icon = "" }, -- group
            { "<leader>s", group = "Split", icon = "" }, -- group
            { "<leader>t", group = "Terminal", icon = "" }, -- group
            { "<leader>b", group = "buffers", expand = function()
                return require("which-key.extras").expand.buf()
            end
            },
        })
    end
}
