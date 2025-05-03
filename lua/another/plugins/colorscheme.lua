return {
    -- {
    --     "sainnhe/gruvbox-material",
    --     config = function()
    --         vim.opt.background = "light" -- set this to dark or light
    --         vim.cmd("colorscheme gruvbox-material")
    --     end,
    -- },

    {
        "kvrohit/rasmus.nvim",
        priority = 1000,
        config = function()
            vim.cmd.colorscheme("rasmus")
        end,
    },
}
