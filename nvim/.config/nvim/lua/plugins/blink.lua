return {
  {
    "saghen/blink.cmp",
    build = "cargo build --release",
    opts = {
      fuzzy = {
        implementation = "rust",
      },
      keymap = {
        ['<C-j>'] = {'select_next'},
        ['<C-k>'] = {'select_prev'},
        ['<Tab>'] = { 'snippet_forward', 'select_and_accept', 'fallback' },
        ["<CR>"]   = false
      },
      completion = {
        menu = {
          direction_priority = { "n", "s" },
        },
        ghost_text = {
          enabled = true,
        },
      },
      sources = {
        default = { "copilot", "lsp", "path", "snippets", "buffer" },
        providers = {
          copilot = {
            name = "copilot",
            module = "blink-copilot",
            score_offset = 100,
            async = true,
            opts = {
              max_completions = 2,
            },
          },
        },
      },
    }
  },
}
