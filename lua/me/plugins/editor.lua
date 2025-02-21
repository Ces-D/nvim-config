return {

    ---------- Lualine ----------
    {
        "nvim-lualine/lualine.nvim",
        lazy = true,
        event = { "VeryLazy" },
        config = function()
            require("lualine").setup({
                options = {
                    icons_enabled = true,
                    disabled_filetypes = { statusline = { "alpha" } },
                    section_separators = { left = "", right = "" },
                    component_separators = "",
                    globalstatus = true,
                },
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = {
                        {
                            "diagnostics",
                            source = { "nvim_diagnostic", "nvim_lsp" },
                            symbols = { error = " ", warn = " ", hint = " ", info = " " },
                        },
                    },
                    lualine_c = { "%=", "%f %m" },
                    lualine_x = { "encoding", "fileformat", "filetype" },
                    lualine_y = { "progress" },
                    lualine_z = { "location" },
                },
                extensions = { "fzf" },
            })
        end,
    },

    ---------- Editor ----------


    {
        "nvim-tree/nvim-tree.lua",
        event = { "VeryLazy" },
        config = function()
            require("nvim-tree").setup({
                update_focused_file = {
                    enable = true,
                },
                view = { width = {} },
                actions = {
                    open_file = {
                        quit_on_open = true,
                    },
                },
            })
            vim.keymap.set("n", "<leader>e", function()
                require("nvim-tree.api").tree.toggle()
            end, { desc = "Toggle Tree" })
        end,
    },

    -- {
    --     "sainnhe/gruvbox-material",
    --     config = function()
    --         vim.g.gruvbox_material_enable_italic = true
    --         vim.opt.background = "dark"
    --         require("me.util").set_colorscheme("gruvbox-material", "gruvbox-material")
    --     end,
    -- },

    {
        "Mofiqul/dracula.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require("dracula").setup({
                -- show the '~' characters after the end of buffers
                show_end_of_buffer = true, -- default false
                -- use transparent background
                transparent_bg = false, -- default false
                -- set italic comment
                italic_comment = true, -- default false
                -- overrides the default highlights with table see `:h synIDattr`
                overrides = {},
                -- You can use overrides as table like this
                -- overrides = {
                --   NonText = { fg = "white" }, -- set NonText fg to white
                --   NvimTreeIndentMarker = { link = "NonText" }, -- link to NonText highlight
                --   Nothing = {} -- clear highlight of Nothing
                -- },
                -- Or you can also use it like a function to get color from theme
                -- overrides = function (colors)
                --   return {
                --     NonText = { fg = colors.white }, -- set NonText fg to white of theme
                --   }
                -- end,
            })
            vim.cmd.colorscheme("dracula")
        end,
    },
}
