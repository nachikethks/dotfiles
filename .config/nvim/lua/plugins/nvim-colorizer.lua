return {
    "norcalli/nvim-colorizer.lua",
    event = { "BufReadPre", "BufNewFile" },
    lazy = true,
    config = function()
        require("colorizer").setup()
    end,
}
