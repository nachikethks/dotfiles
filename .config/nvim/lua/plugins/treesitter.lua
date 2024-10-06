return {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    event = { "BufReadPost", "BufNewFile" },

    config = function()
        require('nvim-treesitter.configs').setup({
            modules = {},
            ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline", "python" },
            ignore_install = {},
            sync_install = false,
            auto_install = true,
            highlight = {
                enable = true,
                disable = function(lang, buf)
                    local max_filesize = 1000 * 1024 -- 1 MB
                    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                    if ok and stats and stats.size > max_filesize then
                        return true
                    end
                    return false
                end
            }
        })
    end
}
