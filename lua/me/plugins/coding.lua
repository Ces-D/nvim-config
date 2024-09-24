return {
    {
        "L3MON4D3/LuaSnip",
        event = { "InsertEnter", "LspAttach" },
        version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
        -- install jsregexp (optional!).
        build = "make install_jsregexp",
    },

    {
        "hrsh7th/nvim-cmp",
        event = { "InsertEnter", "LspAttach" },
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-path",
            "onsails/lspkind.nvim",
        },
        config = function()
            local lspkind = require("lspkind")
            lspkind.init({
                mode = "symbol_text",
                symbol_map = {
                    Copilot = "",
                },
            })

            local luasnip = require("luasnip")
            local cmp = require("cmp")
            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                view = {
                    entries = { name = "custom", selection_order = "near_cursor" },
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
                sources = {
                    -- Copilot Source
                    { name = "copilot", group_index = 2 },
                    -- Other Sources
                    { name = "nvim_lsp", group_index = 2 },
                    { name = "path", group_index = 2 },
                    { name = "luasnip", group_index = 2 },
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
                group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
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
                handlers = {
                    function(server_name)
                        if server_name == "tsserver" then
                            server_name = "ts_ls"
                        end
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

    { -- Fuzzy Finder (files, lsp, etc)
        "nvim-telescope/telescope.nvim",
        event = "VimEnter",
        branch = "0.1.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            { -- If encountering errors, see telescope-fzf-native README for installation instructions
                "nvim-telescope/telescope-fzf-native.nvim",

                -- `build` is used to run some command when the plugin is installed/updated.
                -- This is only run then, not every time Neovim starts up.
                build = "make",

                -- `cond` is a condition used to determine whether this plugin should be
                -- installed and loaded.
                cond = function()
                    return vim.fn.executable("make") == 1
                end,
            },
            -- Useful for getting pretty icons, but requires a Nerd Font.
            { "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
        },
        config = function()
            -- Telescope is a fuzzy finder that comes with a lot of different things that
            -- it can fuzzy find! It's more than just a "file finder", it can search
            -- many different aspects of Neovim, your workspace, LSP, and more!
            --
            -- The easiest way to use Telescope, is to start by doing something like:
            --  :Telescope help_tags
            --
            -- After running this command, a window will open up and you're able to
            -- type in the prompt window. You'll see a list of `help_tags` options and
            -- a corresponding preview of the help.
            --
            -- Two important keymaps to use while in Telescope are:
            --  - Insert mode: <c-/>
            --  - Normal mode: ?
            --
            -- This opens a window that shows you all of the keymaps for the current
            -- Telescope picker. This is really useful to discover what Telescope can
            -- do as well as how to actually do it!

            -- [[ Configure Telescope ]]
            -- See `:help telescope` and `:help telescope.setup()`
            require("telescope").setup({
                defaults = {
                    file_ignore_patterns = {
                        ".git/",
                        "target/",
                        "docs/",
                        "vendor/*",
                        "%.lock",
                        "__pycache__/*",
                        "%.sqlite3",
                        "%.ipynb",
                        "node_modules/*",
                        "%.jpg",
                        "%.jpeg",
                        "%.png",
                        "%.svg",
                        "%.otf",
                        "%.ttf",
                        "%.webp",
                        ".dart_tool/",
                        ".github/",
                        ".gradle/",
                        ".idea/",
                        ".constants/",
                        ".vscode/",
                        "__pycache__/",
                        "build/",
                        "gradle/",
                        "node_modules/",
                        "%.pdb",
                        "%.dll",
                        "%.class",
                        "%.exe",
                        "%.cache",
                        "%.ico",
                        "%.pdf",
                        "%.dylib",
                        "%.jar",
                        "%.docx",
                        "%.met",
                        "smalljre_*/*",
                        ".vale/",
                        "%.burp",
                        "%.mp4",
                        "%.mkv",
                        "%.rar",
                        "%.zip",
                        "%.7z",
                        "%.tar",
                        "%.bz2",
                        "%.epub",
                        "%.flac",
                        "%.tar.gz",
                    },
                    hidden = true,
                    path_display = { truncate = 3 },
                    prompt_prefix = "  ",
                    layout_config = {
                        horizontal = {
                            width = 0.95,
                        },
                    },
                },
                pickers = {
                    buffers = {
                        ignore_current_buffer = true,
                        sort_lastused = false,
                        sort_mru = true,
                    },
                    lsp_references = {
                        include_declaration = true,
                        show_line = false,
                        trim_text = true,
                    },
                },
                extensions = {},
            })

            -- Enable Telescope extensions if they are installed
            pcall(require("telescope").load_extension, "fzf")

            -- See `:help telescope.builtin`
            local builtin = require("telescope.builtin")
            vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
            vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
            vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
            vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
            vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
            vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
            vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
            vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
            vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
            vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })

            -- Slightly advanced example of overriding default behavior and theme
            vim.keymap.set("n", "<leader>/", function()
                -- You can pass additional configuration to Telescope to change the theme, layout, etc.
                builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
                    winblend = 10,
                    previewer = false,
                }))
            end, { desc = "[/] Fuzzily search in current buffer" })

            -- It's also possible to pass additional configuration options.
            --  See `:help telescope.builtin.live_grep()` for information about particular keys
            vim.keymap.set("n", "<leader>s/", function()
                builtin.live_grep({
                    grep_open_files = true,
                    prompt_title = "Live Grep in Open Files",
                })
            end, { desc = "[S]earch [/] in Open Files" })

            -- Shortcut for searching your Neovim configuration files
            vim.keymap.set("n", "<leader>sn", function()
                builtin.find_files({ cwd = vim.fn.stdpath("config") })
            end, { desc = "[S]earch [N]eovim files" })
        end,
    },

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
                    json = { "jq" },
                    markdown = { "mdformat" },
                    rust = { "rustfmt" },
                    css = { "prettierd" },
                    scss = { "prettierd" },
                    bash = { "shfmt" },
                    toml = { "taplo" },
                    yaml = { "yamlfmt" },
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
        event = { "BufRead Cargo.toml" },
        dependencies = { "nvim-lua/plenary.nvim" },
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
    {
        "folke/ts-comments.nvim",
        event = { "BufRead *.tsx" },
        opts = {},
    },

    ---------- Pairs ----------
    {
        "echasnovski/mini.pairs",
        version = "*",
        event = "InsertEnter",
        config = function()
            require("mini.pairs").setup({})
        end,
    },

    {
        "windwp/nvim-ts-autotag",
        event = "InsertEnter *.tsx",
        config = function()
            require("nvim-ts-autotag").setup({
                opts = {
                    enable_close = true, -- Auto close tags
                    enable_rename = true, -- Auto rename pairs of tags
                    enable_close_on_slash = true, -- Auto close on trailing </
                },
            })
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
