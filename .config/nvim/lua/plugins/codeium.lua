return {
    "Exafunction/codeium.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "hrsh7th/nvim-cmp",
    },
    opts = {
        config = {
            tools = {
                -- Override the default notify function to suppress notifications
                notify = function(_, _)
                    -- Do nothing, effectively suppressing the notification
                end,
            },
        }
    },
    config = function(_, opts)
        require('codeium').setup(opts)
        -- Suppress print messages
        local old_print = print
        _G.print = function(...)
            local info = debug.getinfo(2, "S")
            if info and info.source:match("codeium") then
                -- Do nothing for print calls from Codeium
                return
            end
            old_print(...)
        end
    end
}
