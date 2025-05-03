return {
    {
        "nvim-tree/nvim-tree.lua",
        event = { "VeryLazy" },
        config = function()
            require("nvim-tree").setup({
                update_focused_file = {
                    enable = true,
                },
                view = {
                    adaptive_size = true,
                },
                renderer = {
                    add_trailing = true,
                    indent_markers = {
                        enable = true,
                        inline_arrows = true,
                        icons = {
                            corner = "└",
                            edge = "│",
                            item = "│",
                            bottom = "─",
                            none = " ",
                        },
                    },
                },
                actions = {
                    open_file = {
                        quit_on_open = true,
                    },
                },
            })
            require("utils").map("<leader>e", "<CMD>NvimTreeToggle<CR>", "NvimTree: Toggle")
        end,
    },
}
