return {
    'akinsho/toggleterm.nvim',
    version = "*",
    event = { "BufRead" },
    opts = {},
    keys = {
        { '<leader>th', mode = { 'n', 'i', 't' }, '<cmd>ToggleTerm direction=horizontal<CR>',       desc = "Open Terminal Tab" },
        { '<leader>tv', mode = { 'n', 'i', 't' }, '<cmd>ToggleTerm size=40 direction=vertical<CR>', desc = "Open Vertical Terminal" },
        { '<leader>tt', mode = { 'n', 'i', 't' }, '<cmd>ToggleTerm direction=tab<CR>',              desc = "Open Horizontal Terminal" },
        { '<leader>tf', mode = { 'n', 'i', 't' }, '<cmd>ToggleTerm direction=float<CR>',            desc = "Open Floating Terminal" },
        { '<esc>',      mode = { 't' },           [[<C-\><C-n>]],                                   buffer = 0 },
        { '<C-w>',      mode = { 't' },           [[<C-\><C-n><C-w>]],                              buffer = 0 }
    },
    config = function()
        require('toggleterm').setup()
        local Terminal = require('toggleterm.terminal').Terminal
        local lazygit = Terminal:new({ cmd = "lazygit", hidden = true, direction = "float" })

        function _lazygit_toggle()
            lazygit:toggle()
        end

        vim.keymap.set("n", "<leader>tg", "<cmd>lua _lazygit_toggle()<CR>", { desc = "ToggleTerm lazygit" })
    end
}
