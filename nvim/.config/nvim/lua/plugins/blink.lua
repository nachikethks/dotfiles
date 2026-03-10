return {
  {
    "saghen/blink.cmp",
    opts = {
      keymap = {
        ['<C-j>'] = {'select_next'},
        ['<C-k>'] = {'select_prev'},
        ['<Tab>'] = {'select_and_accept'},
        ["<CR>"]   = false
      },
      completion = {
        menu = {
          direction_priority = { "n", "s" },
        },
      },
    }
  },
}
