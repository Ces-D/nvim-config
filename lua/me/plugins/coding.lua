return {
    {
        "L3MON4D3/LuaSnip",
        event = { "InsertEnter", "LspAttach" },
        version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
        -- install jsregexp (optional!).
        build = "make install_jsregexp",
    },

    ---------- AI ----------
    {
        "zbirenbaum/copilot.lua",
        event = "InsertEnter",
        config = function()
            require("copilot").setup({
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
            })
        end,
    },
    {
        "olimorris/codecompanion.nvim",
        event = { "VeryLazy" },
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            "hrsh7th/nvim-cmp", -- Optional: For using slash commands and variables in the chat buffer
            "nvim-telescope/telescope.nvim", -- Optional: For using slash commands
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

            vim.api.nvim_set_keymap("n", "<C-a>", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
            vim.api.nvim_set_keymap("v", "<C-a>", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
            vim.api.nvim_set_keymap(
                "n",
                "<Leader>aa",
                "<cmd>CodeCompanionChat Toggle<cr>",
                { noremap = true, silent = true }
            )
            vim.api.nvim_set_keymap(
                "v",
                "<Leader>aa",
                "<cmd>CodeCompanionChat Toggle<cr>",
                { noremap = true, silent = true }
            )
            vim.api.nvim_set_keymap("v", "ga", "<cmd>CodeCompanionChat Add<cr>", { noremap = true, silent = true })
        end,
    },

    ---------- LSP ----------

    {
        "hrsh7th/nvim-cmp",
        event = { "InsertEnter" },
        dependencies = {
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-path",
            "onsails/lspkind.nvim",
        },
        config = function()
            local lspkind = require("lspkind")

            local luasnip = require("luasnip")
            local cmp = require("cmp")
            cmp.setup({
                preselect = cmp.PreselectMode.None,
                formatting = {
                    expandable_indicator = true,
                    fields = { "abbr", "kind", "menu" },
                    format = lspkind.cmp_format({
                        mode = "text_symbol", -- show only symbol annotations
                        -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
                        -- can also be a function to dynamically calculate max width such as
                        -- maxwidth = function() return math.floor(0.45 * vim.o.columns) end,
                        maxwidth = function()
                            return math.floor(0.45 * vim.o.columns)
                        end,
                        ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
                        show_labelDetails = true, -- show labelDetails in menu. Disabled by default
                        symbol_map = {
                            Copilot = "",
                        },
                    }),
                },
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                view = {
                    docs = { auto_open = true },
                },
                mapping = cmp.mapping.preset.insert({
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<C-u>"] = cmp.mapping.scroll_docs(4), -- scroll up preview
                    ["<C-d>"] = cmp.mapping.scroll_docs(-4), -- scroll down preview
                    ["<C-Space>"] = cmp.mapping.complete({}), -- show completion suggestions
                    ["<C-c>"] = cmp.mapping.abort(), -- close completion window
                    ["<CR>"] = cmp.mapping.confirm({ select = false }), -- select suggestion
                }),
                -- sources for autocompletion
                sources = {
                    { name = "nvim_lsp" },
                    { name = "path" },
                    { name = "luasnip" },
                    -- Other Sources
                    { name = "buffer" },
                },
            })
        end,
    },

    {
        "neovim/nvim-lspconfig",
        lazy = false,
        dependencies = {
            { "williamboman/mason.nvim", config = true },
            "williamboman/mason-lspconfig.nvim",
            "WhoIsSethDaniel/mason-tool-installer.nvim",
            -- `neodev` configures Lua LSP for your Neovim config, runtime and plugins
            -- used for completion, annotations and signatures of Neovim apis
            { "folke/neodev.nvim", opts = {} },
        },
        cmd = { "LspInfo", "LspInstall", "LspUninstall", "Mason" },
        config = function()
            --  This function gets run when an LSP attaches to a particular buffer.
            --    That is to say, every time a new file is opened that is associated with
            --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
            --    function will be executed to configure the current buffer
            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(event)
                    -- NOTE: Remember that Lua is a real programming language, and as such it is possible
                    -- to define small helper and utility functions so you don't have to repeat yourself.
                    --
                    -- In this case, we create a function that lets us more easily define mappings specific
                    -- for LSP related items. It sets the mode, buffer and description for us each time.
                    local map = function(keys, func, desc)
                        vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
                    end

                    -- Jump to the definition of the word under your cursor.
                    --  This is where a variable was first declared, or where a function is defined, etc.
                    --  To jump back, press <C-t>.
                    map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")

                    -- Find references for the word under your cursor.
                    map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")

                    -- Jump to the implementation of the word under your cursor.
                    --  Useful when your language has ways of declaring types without an actual implementation.
                    map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")

                    -- Jump to the type of the word under your cursor.
                    --  Useful when you're not sure what type a variable is and you want to see
                    --  the definition of its *type*, not where it was *defined*.
                    map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")

                    -- Fuzzy find all the symbols in your current document.
                    --  Symbols are things like variables, functions, types, etc.
                    map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")

                    -- Fuzzy find all the symbols in your current workspace.
                    --  Similar to document symbols, except searches over your entire project.
                    map(
                        "<leader>ws",
                        require("telescope.builtin").lsp_dynamic_workspace_symbols,
                        "[W]orkspace [S]ymbols"
                    )

                    -- Rename the variable under your cursor.
                    --  Most Language Servers support renaming across files, etc.
                    map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")

                    -- Execute a code action, usually your cursor needs to be on top of an error
                    -- or a suggestion from your LSP for this to activate.
                    map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

                    -- Opens a popup that displays documentation about the word under your cursor
                    --  See `:help K` for why this keymap.
                    map("K", vim.lsp.buf.hover, "Hover Documentation")

                    -- WARN: This is not Goto Definition, this is Goto Declaration.
                    --  For example, in C this would take you to the header.
                    map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

                    local client = vim.lsp.get_client_by_id(event.data.client_id)

                    -- The following autocommand is used to enable inlay hints in your
                    -- code, if the language server you are using supports them
                    --
                    -- This may be unwanted, since they displace some of your code
                    if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
                        map("<leader>th", function()
                            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
                        end, "[T]oggle Inlay [H]ints")
                    end
                end,
            })

            -- LSP servers and clients are able to communicate to each other what features they support.
            --  By default, Neovim doesn't support everything that is in the LSP specification.
            --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
            --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            -- stuff for nvim-ufo
            capabilities.textDocument.foldingRange = {
                dynamicRegistration = false,
                lineFoldingOnly = true,
            }
            capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

            -- Enable the following language servers
            --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
            --
            --  Add any additional override configuration in the following tables. Available keys are:
            --  - cmd (table): Override the default command used to start the server
            --  - filetypes (table): Override the default list of associated filetypes for the server
            --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
            --  - settings (table): Override the default settings passed when initializing the server.
            --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
            local servers = {
                bashls = {},
                sqlls = {},
                yamlls = {},
                taplo = {},
                cssls = {},
                html = {},
                jsonls = {},
                marksman = {},
                pyright = {},
                tailwindcss = {},
                ts_ls = {},
                rust_analyzer = {
                    settings = {
                        ["rust-analyzer"] = {
                            diagnostic = { enable = true },
                        },
                    },
                },
                lua_ls = {
                    -- cmd = {...},
                    -- filetypes = { ...},
                    -- capabilities = {},
                    settings = {
                        Lua = {
                            completion = { callSnippet = "Replace" },
                            -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
                            -- diagnostics = { disable = { 'missing-fields' } },
                        },
                    },
                },
                prismals = {},
            }

            -- Ensure the servers and tools above are installed
            --  To check the current status of installed tools and/or manually install
            --  other tools, you can run
            --    :Mason
            --
            --  You can press `g?` for help in this menu.
            require("mason").setup()

            -- You can add other tools here that you want Mason to install
            -- for you, so that they are available from within Neovim.
            local ensure_installed = vim.tbl_keys(servers or {})

            require("mason-lspconfig").setup({
                ensure_installed = ensure_installed,
                automatic_installation = true,
                handlers = {
                    function(server_name)
                        local server = servers[server_name] or {}
                        -- This handles overriding only values explicitly passed
                        -- by the server configuration above. Useful when disabling
                        -- certain features of an LSP (for example, turning off formatting for tsserver)
                        server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
                        require("lspconfig")[server_name].setup(server)
                    end,
                },
            })
        end,
    },

    -- Fuzzy Finder (files, lsp, etc)


    { -- Highlight, edit, and navigate code
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        opts = {
            ensure_installed = {
                "bash",
                "html",
                "javascript",
                "json",
                "lua",
                "markdown",
                "markdown_inline",
                "python",
                "tsx",
                "typescript",
                "vim",
                "yaml",
                "lua",
                "css",
                "html",
                "rust",
                "dockerfile",
                "toml",
            },
            -- Autoinstall languages that are not installed
            auto_install = true,
            highlight = {
                enable = true,
                -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
                --  If you are experiencing weird indenting issues, add the language to
                --  the list of additional_vim_regex_highlighting and disabled languages for indent.
                additional_vim_regex_highlighting = {},
            },
            indent = { enable = true, disable = {} },
        },
        config = function(_, opts)
            -- [[ Configure Treesitter ]] See `:help nvim-treesitter`

            -- Prefer git instead of curl in order to improve connectivity in some environments
            require("nvim-treesitter.install").prefer_git = true
            ---@diagnostic disable-next-line: missing-fields
            require("nvim-treesitter.configs").setup(opts)

            -- There are additional nvim-treesitter modules that you can use to interact
            -- with nvim-treesitter. You should go explore a few and see what interests you:
            --
            --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
            --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
            --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
        end,
    },

    {
        "stevearc/conform.nvim",
        event = { "BufReadPost" },
        config = function()
            local conform = require("conform")
            conform.setup({
                notify_on_error = true,
                formatters_by_ft = {
                    lua = { "stylua" },
                    python = { "isort", "black" },
                    javascript = { "eslint_d", "prettierd" },
                    typescript = { "eslint_d", "prettierd" },
                    typescriptreact = { "eslint_d", "prettierd", "rustywind" },
                    svelte = { "eslint_d", "prettierd", "rustywind" },
                    html = { "prettierd" },
                    json = { "jq" },
                    markdown = { "mdformat" },
                    rust = { "rustfmt" },
                    css = { "prettierd" },
                    scss = { "prettierd" },
                    bash = { "shfmt" },
                    toml = { "taplo" },
                    yaml = { "yamlfmt" },
                    sql = { "sql_formatter" },
                },
            })
            vim.keymap.set("n", "<leader>fm", function()
                require("conform").format()
            end, { desc = "Format" })
        end,
    },

    ---------- Rust ----------
    {
        "saecki/crates.nvim",
        tag = "stable",
        event = { "BufRead Cargo.toml" },
        config = function()
            require("crates").setup({})
        end,
    },

    ---------- Github ----------
    {
        "lewis6991/gitsigns.nvim",
        event = "VeryLazy",
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

    ---------- Comment ----------
    -- {
    --     "folke/ts-comments.nvim",
    --     event = { "BufRead *.tsx" },
    --     opts = {},
    -- },

    ---------- Pairs ----------
    {
        "echasnovski/mini.pairs",
        version = "*",
        event = "InsertEnter",
        config = function()
            require("mini.pairs").setup({})
        end,
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
}
