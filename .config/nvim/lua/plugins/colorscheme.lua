return {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1001,
    config = function()
        vim.cmd([[colorscheme catppuccin]])
    end
}
