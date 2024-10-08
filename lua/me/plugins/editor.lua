return {

    ---------- Lualine ----------
    -- {
    --     "nvim-lualine/lualine.nvim",
    --     lazy = true,
    --     event = { "VeryLazy" },
    --     config = function()
    --         require("lualine").setup({
    --             options = {
    --                 icons_enabled = true,
    --                 disabled_filetypes = { statusline = { "alpha" } },
    --                 section_separators = { left = "", right = "" },
    --                 component_separators = "",
    --                 globalstatus = true,
    --             },
    --             sections = {
    --                 lualine_a = { "mode" },
    --                 lualine_b = {
    --                     {
    --                         "diagnostics",
    --                         source = { "nvim_diagnostic", "nvim_lsp" },
    --                         symbols = { error = " ", warn = " ", hint = " ", info = " " },
    --                     },
    --                 },
    --                 lualine_c = { "%=", "%f %m" },
    --                 lualine_x = { "encoding", "fileformat", "filetype" },
    --                 lualine_y = { "progress" },
    --                 lualine_z = { "location" },
    --             },
    --             extensions = { "fzf" },
    --         })
    --     end,
    -- },

    ---------- Editor ----------

    {
        "brenoprata10/nvim-highlight-colors",
        event = "VeryLazy",
        config = function()
            require("nvim-highlight-colors").setup({})
        end,
    },

    {
        "nvim-tree/nvim-tree.lua",
        lazy = false,
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
    --     "sainnhe/edge",
    --     lazy = false,
    --     priority = 1000,
    --     config = function()
    --         vim.opt.background = "dark"
    --         -- Optionally configure and load the colorscheme
    --         -- directly inside the plugin declaration.
    --         vim.g.edge_enable_italic = true
    --         vim.cmd.colorscheme("edge")
    --     end,
    -- },
    --
    {
        "projekt0n/github-nvim-theme",
        name = "github-theme",
        lazy = false, -- make sure we load this during startup if it is your main colorscheme
        priority = 1000, -- make sure to load this before all the other start plugins
        config = function()
            vim.opt.background = "dark"
            local dark_theme = "github_dark"
            local light_theme = "github_light"

            require("github-theme").setup({})

            if vim.o.background == "dark" then
                vim.cmd.colorscheme(dark_theme)
            else
                vim.cmd.colorscheme(light_theme)
            end
        end,
    },

    -- {
    --     "sainnhe/gruvbox-material",
    --     config = function()
    --         vim.opt.background = "dark"
    --         local dark_theme = "gruvbox-material"
    --         local light_theme = "gruvbox-material"
    --
    --         vim.g.gruvbox_material_enable_italic = true
    --
    --         if vim.o.background == "dark" then
    --             vim.cmd.colorscheme(dark_theme)
    --         else
    --             vim.cmd.colorscheme(light_theme)
    --         end
    --
    --         vim.api.nvim_create_autocmd({ "OptionSet" }, {
    --             pattern = { "background" },
    --             callback = function(_)
    --                 if vim.o.background == "dark" then
    --                     vim.cmd.colorscheme(dark_theme)
    --                 else
    --                     vim.cmd.colorscheme(light_theme) -- builtin theme
    --                 end
    --                 vim.cmd("mode") -- force a full redraw:
    --             end,
    --         })
    --     end,
    -- },
}
