return {
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        opts = {
            panel = {
                enabled = false,
                auto_refresh = false,
                keymap = {
                    jump_prev = "[[",
                    jump_next = "]]",
                    accept = "<CR>",
                    refresh = "gr",
                    open = "<M-CR>",
                },
                layout = {
                    position = "bottom", -- | top | left | right
                    ratio = 0.4,
                },
            },
            suggestion = {
                enabled = true,
                auto_trigger = true,
                hide_during_completion = true,
                debounce = 75,
                keymap = {
                    accept = "<C-j>",
                    accept_word = false,
                    accept_line = false,
                    next = "<M-]>",
                    prev = "<M-[>",
                    dismiss = "<C-]>",
                },
            },
            filetypes = {
                yaml = false,
                help = false,
                gitcommit = false,
                gitrebase = false,
                hgcommit = false,
                svn = false,
                cvs = false,
                ["*"] = true,
            },
            server_opts_overrides = {},
        },
    },
    {
        "olimorris/codecompanion.nvim",
        event = "VeryLazy",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
        config = function()
            require("codecompanion").setup({
                adapters = {
                    copilot = function()
                        return require("codecompanion.adapters").extend("copilot", {
                            schema = {
                                model = {
                                    order = 1,
                                    mapping = "parameters",
                                    type = "enum",
                                    desc = "ID of the model to use. See the model endpoint compatibility table for details on which models work with the Chat API.",
                                    ---@type string|fun(): string
                                    default = "claude-3.7-sonnet-thought",
                                    choices = {
                                        ["o3-mini-2025-01-31"] = { opts = { can_reason = true } },
                                        ["o1-2024-12-17"] = { opts = { can_reason = true } },
                                        ["o1-mini-2024-09-12"] = { opts = { can_reason = true } },
                                        "claude-3.5-sonnet",
                                        "claude-3.7-sonnet",
                                        "claude-3.7-sonnet-thought",
                                        "gpt-4o-2024-08-06",
                                        "gemini-2.0-flash-001",
                                    },
                                },
                            },
                        })
                    end,
                },
            })

            local map = require("utils").map
            map("<C-a>", "<cmd>CodeCompanionActions<cr>", "Code Companion Actions", { "n", "v" })
            map("<leader>aa", "<cmd>CodeCompanionChat Toggle<cr>", "Code Companion Chat", { "n", "v" })
            map("ga", "<cmd>CodeCompanionChat Add<cr>", "Code Companion Chat Add", { "v" })
        end,
    },
}
