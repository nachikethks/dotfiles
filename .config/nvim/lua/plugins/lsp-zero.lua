return {
    {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
        build = "make install_jsregexp",
        dependencies = {
            "rafamadriz/friendly-snippets",
        },

        config = function()
            require("luasnip.loaders.from_vscode").lazy_load()
        end,
    },
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v4.x',
        lazy = true,
        config = false,
    },
    {
        'williamboman/mason.nvim',
        lazy = false,
        opts = {
            ui = {
                border = "rounded",
                icons = {
                    package_pending = " ",
                    package_installed = " ",
                    package_uninstalled = " ",
                },
            },
            ensure_installed = {
                "mypy",
                "black",
                "ruff",
                "pyright"
            }
        },
        config = function(_, opts)
            require('mason').setup(opts)
        end
    },

    -- Autocompletion
    {
        'hrsh7th/nvim-cmp',
        event = 'InsertEnter',
        dependencies = {
            { 'L3MON4D3/LuaSnip' },
            { 'onsails/lspkind.nvim' },
            { 'rafamadriz/friendly-snippets' },
            { 'saadparwaiz1/cmp_luasnip' }
        },

        config = function()
            local cmp = require('cmp')
            local luasnip = require('luasnip')
            local cmp_select = { behavior = cmp.SelectBehavior.Select }

            local kind_icons = {
                Text = "",
                Method = "󰆧",
                Function = "󰊕",
                Constructor = "",
                Field = "󰇽",
                Variable = "󰂡",
                Class = "󰠱",
                Interface = "",
                Module = "",
                Property = "󰜢",
                Unit = "",
                Value = "󰎠",
                Enum = "",
                Keyword = "󰌋",
                Snippet = "",
                Color = "󰏘",
                File = "󰈙",
                Reference = "",
                Folder = "󰉋",
                EnumMember = "",
                Constant = "󰏿",
                Struct = "",
                Event = "",
                Operator = "󰆕",
                TypeParameter = "󰅲",
                Codeium = "",
            }

            cmp.setup({
                formatting = {
                    format = function(entry, vim_item)
                        -- Kind icons
                        -- This concatenates the icons with the name of the item kind
                        vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind)
                        -- Source
                        vim_item.menu = ({
                            buffer = "[Buffer]",
                            nvim_lsp = "[LSP]",
                            luasnip = "[LuaSnip]",
                            nvim_lua = "[Lua]",
                            latex_symbols = "[LaTeX]",
                            codeium = "[Codeium]"
                        })[entry.source.name]
                        return vim_item
                    end
                },
                snippet = {
                    expand = function(args)
                        require('luasnip').lsp_expand(args.body)
                    end,
                },
                sources = cmp.config.sources({
                    { name = 'luasnip' },  -- Snippet completions
                    { name = 'codeium' },  -- Codeium completions
                    { name = 'nvim_lsp' }, -- LSP completions
                    { name = 'buffer' },   -- Buffer completions
                    { name = 'path' },     -- File path completions
                    { name = 'nvim_lua' }, -- Lua completions
                    { name = 'calc' },     -- Calculator completions
                }),

                mapping = cmp.mapping.preset.insert({
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.confirm({ select = true })
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if luasnip.jumpable(-1) then luasnip.jump(-1) else fallback() end
                    end, { "i", "s" }),
                    ["<C-k>"] = cmp.mapping.select_prev_item(cmp_select),
                    ["<C-j>"] = cmp.mapping.select_next_item(cmp_select),
                    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-d>'] = cmp.mapping.scroll_docs(4),
                }),
            })
        end
    },

    -- LSP
    {
        'neovim/nvim-lspconfig',
        cmd = { 'LspInfo', 'LspInstall', 'LspStart' },
        event = { 'BufReadPre', 'BufNewFile' },
        dependencies = {
            { 'rafamadriz/friendly-snippets' },
            { 'L3MON4D3/LuaSnip' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },
        },
        config = function()
            local lsp_zero = require('lsp-zero')

            -- lsp_attach is where you enable features that only work
            -- if there is a language server active in the file

            local lsp_attach = function(client, bufnr)
                local opts = { buffer = bufnr }
                local builtin = require('telescope.builtin')
                lsp_zero.ui({
                    float_border = 'rounded',
                    sign_text = {
                        error = '✘',
                        warn = '▲',
                        hint = '⚑',
                        info = '»',
                    },
                })
                lsp_zero.highlight_symbol(client, bufnr)

                vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>',
                    vim.tbl_extend('force', opts, { desc = "Display Signature Info" }))

                vim.keymap.set('n', '<leader>ds', builtin.lsp_document_symbols,
                    { desc = "Find current document symbols" })
                vim.keymap.set('n', '<leader>ws', builtin.lsp_dynamic_workspace_symbols,
                    { desc = "Find workspace symbols" })

                vim.keymap.set('n', 'gd', builtin.lsp_definitions,
                    vim.tbl_extend('force', opts, { desc = "Goto Definition" }))
                vim.keymap.set('n', 'gi', builtin.lsp_implementations,
                    vim.tbl_extend('force', opts, { desc = "Goto Implementation" }))
                vim.keymap.set('n', 'gr', builtin.lsp_references,
                    vim.tbl_extend('force', opts, { desc = "Goto References" }))
                vim.keymap.set('n', '<leader>D', builtin.lsp_type_definitions,
                    vim.tbl_extend('force', opts, { desc = "Type Definition" }))
                vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>',
                    vim.tbl_extend('force', opts, { desc = "Goto Declaration" }))
                vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>',
                    vim.tbl_extend('force', opts, { desc = "Display Signature Info" }))


                vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
                vim.keymap.set({ 'n', 'x' }, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
                vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
            end

            lsp_zero.extend_lspconfig({
                sign_text = true,
                lsp_attach = lsp_attach,
                capabilities = require('cmp_nvim_lsp').default_capabilities()
            })

            require('mason-lspconfig').setup({
                ensure_installed = { 'ruff', 'pyright' },
                handlers = {
                    -- this first function is the "default handler"
                    -- it applies to every language server without a "custom handler"
                    function(server_name)
                        require('lspconfig')[server_name].setup({})
                    end,
                }
            })
        end
    }
}
