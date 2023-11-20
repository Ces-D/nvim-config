local keymaps = require("cesd.plugins.utils.plugin_keymaps")

return {
    {
        "nvim-lualine/lualine.nvim",
        lazy = true,

        event = { "BufReadPost", "BufAdd", "BufNewFile" },
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
                extensions = {
                    "nvim-tree",
                    -- "toggleterm",
                    "fzf",
                },
            })
        end,
    },

    {
        "nvim-tree/nvim-tree.lua",
        event = "BufEnter",
        cmd = {
            "NvimTreeToggle",
            "NvimTreeOpen",
        },
        config = function()
            keymaps.nvim_tree_keymaps()

            local HEIGHT_RATIO = 0.8 -- You can change this
            local WIDTH_RATIO = 0.5 -- You can change this too

            require("nvim-tree").setup({
                disable_netrw = true,
                hijack_cursor = true,
                update_focused_file = { enable = true },
                diagnostics = {
                    enable = false,
                    show_on_dirs = true,
                    show_on_open_dirs = false,
                },
                modified = {
                    enable = true,
                    show_on_dirs = true,
                    show_on_open_dirs = false,
                },
                git = {
                    show_on_dirs = true,
                    show_on_open_dirs = false,
                },
                view = {
                    float = {
                        enable = true,
                        open_win_config = function()
                            local screen_w = vim.opt.columns:get()
                            local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
                            local window_w = screen_w * WIDTH_RATIO
                            local window_h = screen_h * HEIGHT_RATIO
                            local window_w_int = math.floor(window_w)
                            local window_h_int = math.floor(window_h)
                            local center_x = (screen_w - window_w) / 2
                            local center_y = ((vim.opt.lines:get() - window_h) / 2) - vim.opt.cmdheight:get()
                            return {
                                border = "rounded",
                                relative = "editor",
                                row = center_y,
                                col = center_x,
                                width = window_w_int,
                                height = window_h_int,
                            }
                        end,
                    },
                    width = function()
                        return math.floor(vim.opt.columns:get() * WIDTH_RATIO)
                    end,
                },
                renderer = {
                    highlight_modified = "icon",
                    indent_markers = {
                        enable = true,
                    },
                },
                actions = {
                    open_file = {
                        quit_on_open = true,
                    },
                },
            })
        end,
    },

    -- {
    --     "akinsho/toggleterm.nvim",
    --     event = { "BufReadPost", "BufNewFile" },
    --     version = "*",
    --     opts = {
    --         open_mapping = [[<C-\>]],
    --         start_in_insert = true,
    --         direction = "vertical",
    --         autochdir = false,
    --         size = function(term)
    --             if term.direction == "vertical" then
    --                 return vim.o.columns * 0.5
    --             elseif term.direction == "horizontal" then
    --                 return vim.o.lines * 0.3
    --             end
    --         end,
    --         float_opts = { border = "curved", winblend = 3 },
    --     },
    -- },

    {
        "NvChad/nvim-colorizer.lua",
        event = "BufReadPost",
        opts = {
            filetypes = { "*", "!lazy", "!neo-tree" },
            buftype = { "*", "!prompt", "!nofile" },
            user_default_options = {
                RGB = true, -- #RGB hex codes
                RRGGBB = true, -- #RRGGBB hex codes
                names = false, -- "Name" codes like Blue
                RRGGBBAA = true, -- #RRGGBBAA hex codes
                AARRGGBB = false, -- 0xAARRGGBB hex codes
                rgb_fn = true, -- CSS rgb() and rgba() functions
                hsl_fn = true, -- CSS hsl() and hsla() functions
                css = false, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
                css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
                -- Available modes: foreground, background
                -- Available modes for `mode`: foreground, background,  virtualtext
                mode = "background", -- Set the display mode.
                virtualtext = "■",
            },
        },
    },

    {
        "echasnovski/mini.comment",
        version = "*",
        event = "VeryLazy",
        dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
        config = function()
            require("mini.comment").setup({
                options = {
                    ignore_blank_line = true,
                    custom_commentstring = function()
                        return require("ts_context_commentstring.internal").calculate_commentstring()
                            or vim.bo.commentstring
                    end,
                },
                mappings = {
                    comment = "<leader>/",
                },
            })
        end,
    },

    {
        "echasnovski/mini.surround",
        event = "VeryLazy",
        version = false,
        config = function()
            require("mini.surround").setup()
        end,
    },

    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = function()
            require("nvim-autopairs").setup({
                check_ts = true,
            })
        end,
    },

    {
        "windwp/nvim-ts-autotag",
        ft = {
            "html",
            "javascript",
            "typescript",
            "javascriptreact",
            "typescriptreact",
            "svelte",
            "vue",
            "tsx",
            "jsx",
            "xml",
            "markdown",
        },
        opts = {
            enable = true,
            filetypes = {
                "html",
                "javascript",
                "typescript",
                "javascriptreact",
                "typescriptreact",
                "svelte",
                "vue",
                "tsx",
                "jsx",
                "xml",
                "markdown",
            },
        },
    },

    {
        "max397574/better-escape.nvim",
        event = "InsertEnter",
        config = function()
            require("better_escape").setup()
        end,
    },

    { "nvim-tree/nvim-web-devicons" },

    -- {
    --     "projekt0n/github-nvim-theme",
    --     lazy = false, -- make sure we load this during startup if it is your main colorscheme
    --     priority = 1000, -- make sure to load this before all the other start plugins
    --     config = function()
    --         require("github-theme").setup({})

    --         vim.cmd("colorscheme github_dark_dimmed")
    --     end,
    -- },

    -- {
    --     "tinted-theming/base16-vim",
    --     lazy = false, -- make sure we load this during startup if it is your main colorscheme
    --     priority = 1000, -- make sure to load this before all the other start plugins
    --     config = function()
    --         vim.cmd("colorscheme base16-horizon-dark")
    --     end,
    -- },

    {
        "Yazeed1s/oh-lucy.nvim",
        version = "*",
        lazy = false,
        priority = 1000, -- make sure to load this before all the other start plugins
        config = function()
            vim.cmd("colorscheme oh-lucy")
        end,
    },

    {
        "rebelot/kanagawa.nvim",
        lazy = false,
        priority = 999,
        config = function()
            require("kanagawa").setup({
                background = {
                    dark = "dragon",
                    light = "lotus",
                },
            })
        end,
    },
}
