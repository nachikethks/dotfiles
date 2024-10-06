return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons", "arkav/lualine-lsp-progress", "folke/noice.nvim" },
    event = "VeryLazy",
    config = function()
        local lualine = require("lualine")
        local lazy_status = require("lazy.status")

        local function get_root_dir()
            local root = vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
            return '   ' .. root -- Add an icon before the root directory name
        end

        lualine.setup({
            options = {
                theme = "auto",
                component_separators = "|",
                section_separators = { left = " ", right = " " },
                globalstatus = true, -- Use a single statusline
            },
            sections = {
                lualine_a = {
                    { "mode", icon = "" },
                },
                lualine_b = {
                    {
                        "filetype",
                        icon_only = true,
                        separator = "",
                        padding = { left = 1, right = 0 },
                    },
                    {
                        "filename",
                        padding = { left = 0, right = 1 },
                        symbols = {
                            modified = "  ",
                            readonly = "  ",
                            unnamed = "",
                            new_file = "  "
                        }
                    }
                },
                lualine_c = {
                    { "branch", icon = "" },
                    {
                        "diff",
                        symbols = { added = " ", modified = " ", removed = " " },
                        diff_color = {
                            added = { fg = "#98c379" },
                            modified = { fg = "#e5c07b" },
                            removed = { fg = "#e06c75" },
                        },
                        cond = lazy_status.has_changes
                    }
                },
                lualine_x = {
                    {
                        require("noice").api.status.mode.get,
                        cond = require("noice").api.status.mode.has,
                        color = { fg = "#ff9e64" },
                    },              {
                        "diagnostics",

                        -- Table of diagnostic sources, available sources are:
                        --   'nvim_lsp', 'nvim_diagnostic', 'nvim_workspace_diagnostic', 'coc', 'ale', 'vim_lsp'.
                        -- or a function that returns a table as such:
                        --   { error=error_cnt, warn=warn_cnt, info=info_cnt, hint=hint_cnt }
                        sources = { "nvim_diagnostic" },

                        -- Displays diagnostics for the defined severity types
                        sections = { "error", "warn", "info", "hint" },

                        diagnostics_color = {
                            -- Same values as the general color option can be used here.
                            error = "DiagnosticError", -- Changes diagnostics' error color.
                            warn = "DiagnosticWarn",   -- Changes diagnostics' warn color.
                            info = "DiagnosticInfo",   -- Changes diagnostics' info color.
                            hint = "DiagnosticHint",   -- Changes diagnostics' hint color.
                        },
                        symbols = { error = '✘', warn = '▲', hint = '⚑', info = '»' },
                        colored = true,           -- Displays diagnostics status in color if set to true.
                        update_in_insert = false, -- Update diagnostics in insert mode.
                        always_visible = false,   -- Show diagnostics even if there are none.
                    },
                    { "searchcount", icon = "" },
                    {
                        'lsp_progress',
                        separators = {
                            component = ' ',
                            progress = ' | ',
                            percentage = { pre = '', post = '%% ' },
                            title = { pre = '', post = ': ' },
                            lsp_client_name = { pre = '  LSP ~ ', post = '' },
                            spinner = { pre = '', post = '' },
                            message = { pre = '(', post = ')', commenced = 'In Progress', completed = 'Completed' },
                        },
                        display_components = { 'lsp_client_name', 'spinner', { 'title', 'percentage', 'message' } },
                        timer = { progress_enddelay = 1000, spinner = 1000, lsp_client_name_enddelay = 1000 * 60 * 60 * 24 },
                        spinner_symbols = { '🌑 ', '🌒 ', '🌓 ', '🌔 ', '🌕 ', '🌖 ', '🌗 ', '🌘 ' },
                    }
                },
                lualine_y = {
                    { "progress", icon = "" },
                    { "location", icon = "" },
                },
                lualine_z = {
                    get_root_dir,
                },
            },
            tabline = {},
            winbar = {},
            extensions = {},
        })
    end,
}
