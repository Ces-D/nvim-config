return {
    ---------- CMP & AutoPairs ----------
    {
        "hrsh7th/nvim-cmp",
        event = { "InsertEnter" },
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-path",
            {
                "L3MON4D3/LuaSnip",
                version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
                -- install jsregexp (optional!).
                build = "make install_jsregexp",
            },
            "saadparwaiz1/cmp_luasnip",
            { "windwp/nvim-ts-autotag", ft = { "ts", "tsx" } },
            "windwp/nvim-autopairs",
        },
        config = function()
            local cmp_autopairs = require("nvim-autopairs.completion.cmp")
            local cmp = require("cmp")
            local luasnip = require("luasnip")

            require("nvim-autopairs").setup()

            -- Integrate nvim-autopairs with cmp
            cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

            -- Load snippets
            require("luasnip.loaders.from_vscode").lazy_load()

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                completion = { completeopt = "menu,menuone,noinsert" },
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
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
                    ["<CR>"] = cmp.mapping.confirm({ select = true }), -- select suggestion
                }),
                -- sources for autocompletion
                sources = cmp.config.sources({
                    { name = "nvim_lsp" }, -- lsp
                    { name = "path", max_item_count = 3 }, -- file system paths
                    { name = "luasnip", max_item_count = 3 }, -- snippets
                }),
            })
        end,
    },

    ---------- LSP & Formatting ----------
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPost" },
        cmd = { "LspInfo", "LspInstall", "LspUninstall", "Mason" },
        dependencies = {
            -- Plugin and UI to automatically install LSPs to stdpath
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",

            "hrsh7th/cmp-nvim-lsp",
            { -- Autoformat
                "stevearc/conform.nvim",
                opts = {
                    notify_on_error = true,
                    formatters_by_ft = {
                        lua = { "stylua" },
                        python = { "isort", "black" },
                        javascript = { "eslint_d", "prettierd" },
                        typescript = { "eslint_d", "prettierd" },
                        typescriptreact = { "eslint_d", "prettierd", "rustywind" },
                        json = { "jq" },
                        markdown = { "mdformat" },
                        rust = { "rustfmt" },
                        toml = { "taplo" },
                        css = { "prettierd" },
                        scss = { "prettierd" },
                    },
                },
            },

            -- Install neodev for better nvim configuration and plugin authoring via lsp configurations
            "folke/neodev.nvim",
        },
        config = function()
            local map_lsp_keybinds = require("user.keymaps").map_lsp_keybinds -- Has to load keymaps before pluginslsp

            -- Use neodev to configure lua_ls in nvim directories - must load before lspconfig
            require("neodev").setup()

            -- Setup mason so it can manage 3rd party LSP servers
            require("mason").setup({
                ui = { border = "rounded" },
            })

            -- Configure mason to auto install servers
            require("mason-lspconfig").setup({
                -- automatic_installation = { exclude = { "ocamllsp", "gleam" } },
            })

            -- LSP servers to install (see list here: https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers )
            local servers = {
                bashls = {},
                cssls = {},
                html = {},
                jsonls = {
                    -- Schemas https://www.schemastore.org
                    schemas = {
                        {
                            fileMatch = { "package.json" },
                            url = "https://json.schemastore.org/package.json",
                        },
                        {
                            fileMatch = { "tsconfig*.json" },
                            url = "https://json.schemastore.org/tsconfig.json",
                        },
                        {
                            fileMatch = {
                                ".prettierrc",
                                ".prettierrc.json",
                                "prettier.config.json",
                            },
                            url = "https://json.schemastore.org/prettierrc.json",
                        },
                        {
                            fileMatch = { ".eslintrc", ".eslintrc.json" },
                            url = "https://json.schemastore.org/eslintrc.json",
                        },
                        {
                            fileMatch = {
                                ".babelrc",
                                ".babelrc.json",
                                "babel.config.json",
                            },
                            url = "https://json.schemastore.org/babelrc.json",
                        },
                        {
                            fileMatch = { "/.github/workflows/*" },
                            url = "https://json.schemastore.org/github-workflow.json",
                        },
                    },
                },
                lua_ls = {
                    settings = {
                        Lua = {
                            diagnostics = {
                                globals = { "vim" },
                                disable = { "different-requires" },
                            },
                            workspace = { checkThirdParty = false },
                            telemetry = { enabled = false },
                        },
                    },
                },
                marksman = {},
                pyright = {},
                tailwindcss = {},
                tsserver = {},
                rust_analyzer = {
                    settings = {
                        ["rust-analyzer"] = {
                            imports = {
                                granularity = { group = "module" },
                            },
                            cargo = {
                                buildScripts = { enable = true },
                            },
                            procMacro = { enable = true },
                            inlayHints = {
                                bindingModeHints = {
                                    enable = false,
                                },
                                chainingHints = {
                                    enable = true,
                                },
                                closingBraceHints = {
                                    enable = true,
                                    minLines = 25,
                                },
                                closureReturnTypeHints = {
                                    enable = "never",
                                },
                                lifetimeElisionHints = {
                                    enable = "never",
                                    useParameterNames = false,
                                },
                                maxLength = 25,
                                parameterHints = {
                                    enable = true,
                                },
                                reborrowHints = {
                                    enable = "never",
                                },
                                renderColons = true,
                                typeHints = {
                                    enable = true,
                                    hideClosureInitialization = false,
                                    hideNamedConstructor = false,
                                },
                            },
                        },
                    },
                },
            }

            -- Default handlers for LSP
            local default_handlers = {
                ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded", max_width = 660 }),
                ["textDocument/signatureHelp"] = vim.lsp.with(
                    vim.lsp.handlers.signature_help,
                    { border = "rounded", max_width = 660 }
                ),
            }

            -- nvim-cmp supports additional completion capabilities
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            local default_capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

            local on_attach = function(_client, buffer_number)
                -- Pass the current buffer to map lsp keybinds
                map_lsp_keybinds(buffer_number)
                if _client.name == "rust_analyzer" then
                    vim.lsp.inlay_hint.enable(true, { bufnr = buffer_number })
                end

                -- Create a command `:Format` local to the LSP buffer
                vim.api.nvim_buf_create_user_command(buffer_number, "Format", function(_)
                    vim.lsp.buf.format({
                        filter = function(format_client)
                            -- Use Prettier to format TS/JS if it's available
                            return format_client.name ~= "tsserver"
                        end,
                    })
                end, { desc = "LSP: Format current buffer with LSP" })
            end

            -- Iterate over our servers and set them up
            for name, config in pairs(servers) do
                require("lspconfig")[name].setup({
                    capabilities = default_capabilities,
                    filetypes = config.filetypes,
                    handlers = vim.tbl_deep_extend("force", {}, default_handlers, config.handlers or {}),
                    on_attach = on_attach,
                    settings = config.settings,
                })
            end

            -- Configure borderd for LspInfo ui
            require("lspconfig.ui.windows").default_options.border = "rounded"

            -- Configure diagostics border
            vim.diagnostic.config({
                float = { border = "rounded" },
            })
        end,
    },

    ---------- Telescope ----------
    {
        "nvim-telescope/telescope.nvim",
        event = "VeryLazy",
        branch = "0.1.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
                cond = vim.fn.executable("cmake") == 1,
            },
        },
        config = function()
            -- local actions = require("telescope.actions")

            require("telescope").setup({
                defaults = {
                    file_ignore_patterns = require("constants")["telescope_ignore_patterns"],
                    hidden = true,
                    path_display = { truncate = 3 },
                    prompt_prefix = "  ",
                },
                pickers = {
                    buffers = {
                        ignore_current_buffer = true,
                        sort_lastused = true,
                        sort_mru = false,
                    },
                    lsp_references = {
                        include_declaration = true,
                        show_line = false,
                        trim_text = true,
                    },
                },
                extensions = {
                    fzf = {
                        fuzzy = true, -- false will only do exact matching
                        override_generic_sorter = true, -- override the generic sorter
                        override_file_sorter = true, -- override the file sorter
                        case_mode = "smart_case", -- or "ignore_case" or "respect_case"
                    },
                },
            })

            -- Enable telescope fzf native, if installed
            pcall(require("telescope").load_extension, "fzf")
        end,
    },

    ---------- Treesitter ----------
    {
        "nvim-treesitter/nvim-treesitter",
        build = function()
            require("nvim-treesitter.install").update({ with_sync = true })
        end,
        event = { "BufEnter" },
        dependencies = {
            -- Additional text objects for treesitter
            "nvim-treesitter/nvim-treesitter-textobjects",
        },
        config = function()
            ---@diagnostic disable: missing-fields
            require("nvim-treesitter.configs").setup({
                ensure_installed = require("constants")["treesitter_servers"],
                sync_install = false,
                highlight = {
                    enable = true,
                },
                indent = {
                    enable = true,
                },
                autopairs = {
                    enable = true,
                },
                autotag = {
                    enable = true,
                },
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = "<c-space>",
                        node_incremental = "<c-space>",
                        scope_incremental = "<c-s>",
                        node_decremental = "<c-backspace>",
                    },
                },
                textobjects = {
                    select = {
                        enable = true,
                        lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
                        keymaps = {
                            -- You can use the capture groups defined in textobjects.scm
                            ["aa"] = "@parameter.outer",
                            ["ia"] = "@parameter.inner",
                            ["af"] = "@function.outer",
                            ["if"] = "@function.inner",
                            ["ac"] = "@class.outer",
                            ["ic"] = "@class.inner",
                        },
                    },
                    move = {
                        enable = true,
                        set_jumps = true, -- whether to set jumps in the jumplist
                        goto_next_start = {
                            ["]m"] = "@function.outer",
                            ["]]"] = "@class.outer",
                        },
                        goto_next_end = {
                            ["]M"] = "@function.outer",
                            ["]["] = "@class.outer",
                        },
                        goto_previous_start = {
                            ["[m"] = "@function.outer",
                            ["[["] = "@class.outer",
                        },
                        goto_previous_end = {
                            ["[M"] = "@function.outer",
                            ["[]"] = "@class.outer",
                        },
                    },
                },
            })
        end,
    },

    ---------- Rust ----------
    {
        "saecki/crates.nvim",
        event = { "BufRead Cargo.toml" },
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("crates").setup({})
        end,
    },

    ---------- Copilot ----------
    -- {
    --     "zbirenbaum/copilot.lua",
    --     event = { "InsertEnter" },
    --     config = function()
    --         require("copilot").setup({
    --             auto_refresh = true,
    --             suggestion = {
    --                 keymap = require("user.keymaps").copilot,
    --                 enabled = true,
    --                 auto_trigger = true,
    --             },
    --         })
    --     end,
    -- },

    ---------- Github ----------
    {
        "lewis6991/gitsigns.nvim",
        event = "VeryLazy",
        config = function()
            require("gitsigns").setup()
        end,
    },

    ---------- Comment ----------
    {
        "folke/ts-comments.nvim",
        event = "VeryLazy",
        opts = {},
        enabled = vim.fn.has("nvim-0.10.0") == 1,
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

    ---------- Oil ----------
    {
        "stevearc/oil.nvim",
        event = "VeryLazy",
        opts = {},
        -- Optional dependencies
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },

    ---------- Editor ----------

    {
        "brenoprata10/nvim-highlight-colors",
        event = "VeryLazy",
        config = function()
            require("nvim-highlight-colors").setup({})
        end,
    },

    ---------- ColorScheme ----------

    {
        "ramojus/mellifluous.nvim",
        config = function()
            require("mellifluous").setup({
                -- color_set = "mellifluous",
                -- color_set = "alduin",
                color_set = "mountain",
                -- color_set = "tender",
                dim_inactive = true,
                transparent_background = {
                    enabled = false,
                },
                styles = { -- see :h attr-list for options. set {} for NONE, { option = true } for option
                    comments = { italic = true },
                    conditionals = {},
                    folds = {},
                    loops = {},
                    functions = {},
                    keywords = {},
                    strings = {},
                    variables = {},
                    numbers = {},
                    booleans = {},
                    properties = {},
                    types = {},
                    operators = {},
                    markup = {
                        headings = { bold = true },
                    },
                },
                flat_background = {
                    line_numbers = true,
                    floating_windows = true,
                    file_tree = false,
                    cursor_line_number = false,
                },
            })
            vim.opt.background = "dark"
            -- vim.cmd("colorscheme mellifluous")
        end,
    },
}
