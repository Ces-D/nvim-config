return {
    ---------- Pairs ----------
    {
        "echasnovski/mini.pairs",
        version = "*",
        event = "InsertEnter",
        opts = {},
    },

    {
        "windwp/nvim-ts-autotag",
        event = "BufReadPre",
        config = function()
            require("nvim-ts-autotag").setup({
                opts = {
                    -- Defaults
                    enable_close = true, -- Auto close tags
                    enable_rename = true, -- Auto rename pairs of tags
                    enable_close_on_slash = false, -- Auto close on trailing </
                },
            })
        end,
    },

    ---------- Surround ----------
    {
        "echasnovski/mini.surround",
        version = "*",
        event = "VeryLazy",
        opts = {},
    },
}
