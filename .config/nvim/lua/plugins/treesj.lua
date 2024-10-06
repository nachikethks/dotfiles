return {
    'Wansmer/treesj',
    event = {"BufReadPre", "BufNewFile"},
    keys = { { '<leader>m', "<cmd>TSJToggle<cr>", desc = "Split or Join Code block" } },
    dependencies = { 'nvim-treesitter/nvim-treesitter' }, -- if you install parsers with `nvim-treesitter`
    opts={
        max_join_length = 300,
        use_default_keymaps = false
    }
}
