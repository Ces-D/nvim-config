return {
    -- {
    --     "sainnhe/gruvbox-material",
    --     lazy = false,
    --     config = function()
    --         vim.g.gruvbox_material_background = "hard"
    --         vim.g.gruvbox_material_enable_italic = true
    --         vim.cmd.colorscheme("gruvbox-material")
    --     end,
    -- },

    -- {
    --     "catppuccin/nvim",
    --     name = "catppuccin",
    --     priority = 1000,
    --     config = function()
    --         require("catppuccin").setup({
    --             flavour = "auto", -- latte, frappe, macchiato, mocha
    --             transparent_background = false,
    --             term_colors = false,
    --             styles = {
    --                 comments = { "italic" },
    --                 conditionals = { "italic" },
    --                 functions = { "bold" },
    --                 keywords = {},
    --                 strings = {},
    --                 variables = {},
    --             },
    --         })
    --         vim.cmd.colorscheme("catppuccin")
    --     end,
    -- },

    -- {
    --     "no-clown-fiesta/no-clown-fiesta.nvim",
    --     priority = 1000,
    --     config = function()
    --         require("no-clown-fiesta").setup({
    --             transparent = false, -- Enable this to disable the bg color
    --             styles = {
    --                 -- You can set any of the style values specified for `:h nvim_set_hl`
    --                 comments = { italic = true },
    --                 functions = { bold = true },
    --                 keywords = {},
    --                 lsp = { underline = false },
    --                 match_paren = { underline = true },
    --                 type = { bold = true },
    --                 variables = {},
    --             },
    --         })
    --
    --         vim.cmd.colorscheme("no-clown-fiesta")
    --     end,
    -- },

    {
        "oahlen/iceberg.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd.colorscheme("iceberg")
        end,
    },
}
