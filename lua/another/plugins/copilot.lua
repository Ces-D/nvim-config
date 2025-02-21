return {
    {
        "zbirenbaum/copilot.lua",
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
                markdown = false,
                help = false,
                gitcommit = false,
                gitrebase = false,
                hgcommit = false,
                svn = false,
                cvs = false,
                ["."] = true,
            },
            copilot_node_command = "node", -- Node.js version must be > 18.x
            server_opts_overrides = {},
        },
    },
    {
        "olimorris/codecompanion.nvim",
        lazy = true,
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            "hrsh7th/nvim-cmp", -- Optional: For using slash commands and variables in the chat buffer
        },
        config = function()
            require("codecompanion").setup({
                copilot = function()
                    return require("codecompanion.adapters").extend("copilot", {
                        name = "copilot-claude", -- Give this adapter a different name to differentiate it from the default ollama adapter
                        schema = {
                            model = {
                                default = "claude-3.5-sonnet",
                            },
                            num_ctx = {
                                default = 16384,
                            },
                            num_predict = {
                                default = -1,
                            },
                        },
                    })
                end,
                display = {
                    diff = {
                        provider = "mini_diff",
                    },
                },
                opts = {
                    log_level = "DEBUG",
                },
            })
            local map = require("utils").map
            map("<C-a>", "<cmd>CodeCompanionActions<cr>", "Code Companion Actions", { "n", "v" })
            map("<leader>aa", "<cmd>CodeCompanionChat Toggle<cr>", "Code Companion Chat", { "n", "v" })
            map("ga", "<cmd>CodeCompanionChat Add<cr>", "Code Companion Chat Add", { "v" })
        end,
    },
}
