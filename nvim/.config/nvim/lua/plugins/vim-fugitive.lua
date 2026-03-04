return {
    "tpope/vim-fugitive",
    event = "VeryLazy",  -- lazy-load when idle
    config = function()
        -- Optional: some useful commands
        vim.api.nvim_set_keymap("n", "<leader>gs", ":Gstatus<CR>", { noremap = true, silent = true })
        vim.api.nvim_set_keymap("n", "<leader>gd", ":Gdiffsplit<CR>", { noremap = true, silent = true })
    end,
}
