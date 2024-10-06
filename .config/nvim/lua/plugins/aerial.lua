return {
    'stevearc/aerial.nvim',
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons"
    },
    keys = {
        { "<leader>a", "<cmd>AerialToggle!<CR>", desc = "Toggle Aerial" },
        { "{",         "<cmd>AerialPrev<CR>",    desc = "Aerial Previous" },
        { "}",         "<cmd>AerialNext<CR>",    desc = "Aerial Next" }
    },
    opts = {
        backends = { 'treesitter', 'lsp' },
    }
}
