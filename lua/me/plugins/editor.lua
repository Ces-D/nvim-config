return {
    -- See `:help gitsigns` to understand what the configuration keys do
    { -- Adds git related signs to the gutter, as well as utilities for managing changes
        "lewis6991/gitsigns.nvim",
        opts = {
            signs = {
                add = { text = "+" },
                change = { text = "~" },
                delete = { text = "_" },
                topdelete = { text = "‾" },
                changedelete = { text = "~" },
            },
        },
    },
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
            })
            vim.keymap.set("n", "<leader>e", function()
                require("nvim-tree.api").tree.toggle()
            end, { desc = "Toggle Tree" })
        end,
    },

    {

        "aktersnurra/no-clown-fiesta.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            if vim.o.background == "dark" then
                vim.cmd.colorscheme("no-clown-fiesta")
            else
                vim.cmd.colorscheme("default")
            end

            vim.api.nvim_create_autocmd({ "OptionSet" }, {
                pattern = { "background" },
                callback = function(ev)
                    if vim.o.background == "dark" then
                        -- vim.cmd.colorscheme("lunaperche") -- builtin theme
                        vim.cmd.colorscheme("sorbet") -- builtin theme
                        -- vim.cmd.colorscheme("no-clown-fiesta")
                    else
                        -- vim.cmd.colorscheme("default") -- builtin theme
                        vim.cmd.colorscheme("zellner") -- builtin theme
                    end
                    -- force a full redraw:
                    vim.cmd("mode")
                end,
            })
        end,
    },
}
