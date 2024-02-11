return {
    ---------- CMP & AutoPairs ----------
    {
        "hrsh7th/nvim-cmp",
        event = { "BufReadPost", "BufNewFile" },
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-path",
            "L3MON4D3/LuaSnip",
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
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
                    ["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
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
            -- Install none-ls for diagnostics, code actions, and formatting
            "nvimtools/none-ls.nvim",

            -- Install neodev for better nvim configuration and plugin authoring via lsp configurations
            "folke/neodev.nvim",
        },
        config = function()
            local null_ls = require("null-ls")
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
                        },
                    },
                },
            }

            -- Default handlers for LSP
            local default_handlers = {
                ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" }),
                ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" }),
            }

            -- nvim-cmp supports additional completion capabilities
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            local default_capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

            ---@diagnostic disable-next-line: unused-local
            local on_attach = function(_client, buffer_number)
                -- Pass the current buffer to map lsp keybinds
                map_lsp_keybinds(buffer_number)

                -- Create a command `:Format` local to the LSP buffer
                vim.api.nvim_buf_create_user_command(buffer_number, "Format", function(_)
                    vim.lsp.buf.format({
                        filter = function(format_client)
                            -- Use Prettier to format TS/JS if it's available
                            return format_client.name ~= "tsserver" or not null_ls.is_registered("prettier")
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

            -- Configure LSP linting, formatting, diagnostics, and code actions
            local formatting = null_ls.builtins.formatting
            local diagnostics = null_ls.builtins.diagnostics
            local code_actions = null_ls.builtins.code_actions

            null_ls.setup({
                border = "rounded",
                sources = {
                    -- formatting
                    formatting.prettierd,
                    formatting.stylua,
                    formatting.black,
                    formatting.mdformat,
                    formatting.rustfmt,
                    formatting.shfmt,
                    formatting.taplo,

                    -- diagnostics
                    diagnostics.eslint_d.with({
                        condition = function(utils)
                            return utils.root_has_file({ ".eslintrc.js", ".eslintrc.cjs", ".eslintrc.json" })
                        end,
                    }),

                    -- code actions
                    code_actions.eslint_d.with({
                        condition = function(utils)
                            return utils.root_has_file({ ".eslintrc.js", ".eslintrc.cjs", ".eslintrc.json" })
                        end,
                    }),
                },
            })

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
            local actions = require("telescope.actions")

            require("telescope").setup({
                defaults = {
                    mappings = {
                        i = {
                            ["<C-k>"] = actions.move_selection_previous,
                            ["<C-j>"] = actions.move_selection_next,
                            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
                            ["<C-x>"] = actions.delete_buffer,
                        },
                    },
                    file_ignore_patterns = require("user.constants")["telescope_ignore_patterns"],
                    hidden = true,
                    path_display = { truncate = 3 },
                },
                pickers = {
                    buffers = {
                        ignore_current_buffer = true,
                        sort_lastused = true,
                        sort_mru = true,
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
                ensure_installed = require("user.constants")["treesitter_servers"],
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
    {
        "zbirenbaum/copilot.lua",
        event = { "InsertEnter" },
        config = function()
            require("copilot").setup({
                suggestion = {
                    enabled = true,
                },
                panel = { enabled = false },
            })
        end,
    },

    ---------- Github ----------
    {
        "lewis6991/gitsigns.nvim",
        event = "VeryLazy",
        config = function()
            require("gitsigns").setup()
        end,
    },

    ---------- Harpoon ----------
    {
        "ThePrimeagen/harpoon",
        event = { "BufEnter" },
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("harpoon"):setup({})
        end,
    },

    ---------- Comment ----------
    {
        "echasnovski/mini.comment",
        version = "*",
        event = { "VeryLazy" },
        config = function()
            require("mini.comment").setup({})
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

    ---------- Lualine ----------
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

    ---------- Oil ----------
    {
        "stevearc/oil.nvim",
        event = { "VeryLazy" },
        opts = {},
        -- Optional dependencies
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },

    ---------- ColorScheme ----------
    {
        "felipeagc/fleet-theme-nvim",
        config = function()
            vim.cmd("colorscheme fleet")
        end,
    },
}
