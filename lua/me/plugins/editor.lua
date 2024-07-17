return {
    ---------- Surround ----------
    {
        "echasnovski/mini.surround",
        version = "*",
        event = "VeryLazy",
        config = function()
            require("mini.surround").setup()
        end,
    },

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
    --     "aktersnurra/no-clown-fiesta.nvim",
    --     lazy = false,
    --     priority = 1000,
    --     config = function()
    --         vim.opt.background = "light"
    --         if vim.o.background == "dark" then
    --             vim.cmd.colorscheme("no-clown-fiesta")
    --         else
    --             vim.cmd.colorscheme("default")
    --         end
    --
    --         vim.api.nvim_create_autocmd({ "OptionSet" }, {
    --             pattern = { "background" },
    --             callback = function(ev)
    --                 if vim.o.background == "dark" then
    --                     -- vim.cmd.colorscheme("lunaperche") -- builtin theme
    --                     vim.cmd.colorscheme("default") -- builtin theme
    --                     -- vim.cmd.colorscheme("no-clown-fiesta")
    --                 else
    --                     -- vim.cmd.colorscheme("default") -- builtin theme
    --                     vim.cmd.colorscheme("zellner") -- builtin theme
    --                 end
    --                 -- force a full redraw:
    --                 vim.cmd("mode")
    --             end,
    --         })
    --     end,
    -- },

    {
        "miikanissi/modus-themes.nvim",
        priority = 1000,
        lazy = false,
        config = function()
            vim.opt.background = "light"
            -- Default options
            require("modus-themes").setup({
                -- Theme comes in two styles `modus_operandi` and `modus_vivendi`
                -- `auto` will automatically set style based on background set with vim.o.background
                style = "auto",
                variant = "default", -- Theme comes in four variants `default`, `tinted`, `deuteranopia`, and `tritanopia`
                transparent = false, -- Transparent background (as supported by the terminal)
                dim_inactive = false, -- "non-current" windows are dimmed
                hide_inactive_statusline = false, -- Hide statuslines on inactive windows. Works with the standard **StatusLine**, **LuaLine** and **mini.statusline**
                styles = {
                    -- Style to be applied to different syntax groups
                    -- Value is any valid attr-list value for `:help nvim_set_hl`
                    comments = { italic = true },
                    keywords = { italic = true },
                    functions = {},
                    variables = {},
                },
            })
            vim.cmd.colorscheme("modus") -- modus_operandi, modus_vivendi
        end,
    },
}
