return {
    {
        "ibhagwan/fzf-lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        event = "VeryLazy",
        opts = {},
        config = function()
            local fzf = require("fzf-lua")
            local map = require("ces/utils").map
            fzf.setup({
                winopts = {
                    height = 0.95, -- window height
                    width = 0.90, -- window width
                    row = 0.35, -- window row position (0=top, 1=bottom)
                    col = 0.50, -- window col position (0=left, 1=right)
                    border = "rounded",
                    backdrop = 60,
                    preview = {
                        border = "rounded", -- preview border: accepts both `nvim_open_win`
                        wrap = false, -- preview line wrap (fzf's 'wrap|nowrap')
                        hidden = false, -- start preview hidden
                        vertical = "down:45%", -- up|down:size
                        horizontal = "right:60%", -- right|left:size
                        layout = "flex", -- horizontal|vertical|flex
                        flip_columns = 100, -- #cols to switch to horizontal on flex
                        -- Only used with the builtin previewer:
                        title = true, -- preview border title (file/buf)?
                        title_pos = "center", -- left|center|right, title alignment
                    },
                },
                keymap = {
                    -- Keys that work inside the picker window
                    builtin = {
                        ["<C-j>"] = "down",
                        ["<C-k>"] = "up",
                        ["<C-u>"] = "preview-page-up",
                        ["<C-d>"] = "preview-page-down",
                    },
                    fzf = {
                        ["ctrl-j"] = "down",
                        ["ctrl-k"] = "up",
                        ["ctrl-u"] = "preview-page-up",
                        ["ctrl-d"] = "preview-page-down",
                    },
                },
                actions = {
                    files = {
                        -- open / split / vsplit / tab like most editors
                        ["enter"] = fzf.actions.file_switch_or_edit,
                        ["ctrl-x"] = fzf.actions.file_split,
                        ["ctrl-v"] = fzf.actions.file_vsplit,
                        ["ctrl-t"] = fzf.actions.file_tabedit,
                    },
                },
            })
            map("<leader>e", function()
                fzf.files({
                    git_icons = true,
                    file_icons = true,
                    formatter = "path.filename_first",
                    color_icons = true,
                    hidden = false,
                    no_ignore = true,
                })
            end, "Fzf: Files")
            map("<leader>fg", fzf.git_status, "Fzf: Git Files")
            map("<c-tab>", function()
                fzf.buffers({
                    file_icons = true,
                    color_icons = true,
                    show_unloaded = false,
                })
            end, "Fzf: Buffers")
            map("g/", function()
                fzf.grep({
                    rg_opts = "--no-heading --color=always --smart-case --max-columns=150 -e",
                    git_icons = true,
                    file_icons = true,
                    color_icons = true,
                })
            end, "Fzf: Global Grep")
            map("/", function()
                fzf.grep_curbuf({
                    rg_opts = "--no-heading --color=always --smart-case --max-columns=150 -e",
                    git_icons = true,
                    file_icons = true,
                    color_icons = true,
                })
            end, "Fzf: Grep Current Buffer")
            map("<leader>fk", function()
                fzf.keymaps()
            end, "Fzf: Keymaps")
            map("<leader>ds", function()
                fzf.lsp_document_symbols({ locate = true })
            end, "Fzf: Document Symbols")
        end,
    },
}
