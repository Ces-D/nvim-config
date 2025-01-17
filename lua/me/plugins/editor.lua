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
        "NvChad/nvim-colorizer.lua",
        event = "VeryLazy",
        config = function()
            require("colorizer").setup({
                filetypes = {
                    "svelte",
                    "javascript",
                    "typescript",
                    "javascriptreact",
                    "typescriptreact",
                    "html",
                    "css",
                    "less",
                    "sass",
                    "scss",
                    "lua",
                    "vue",
                    "json",
                    "yaml",
                    "toml",
                    "md",
                    "markdown",
                },
            })
        end,
    },

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
        "wtfox/jellybeans.nvim",
        priority = 1000,
        config = function()
            require("jellybeans").setup({
                style = "light", -- "dark" or "light"
                transparent = false,
                italics = true,
                plugins = {
                    all = false,
                    auto = true, -- will read lazy.nvim and apply the colors for plugins that are installed
                },
            })
            require("me.util").set_colorscheme("jellybeans", "jellybeans")
        end,
    },
}
