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
                    indent_width = 4,
                    add_trailing = true,
                    indent_markers = {
                        enable = false,
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
            require("utils").map("<leader>ff", "<CMD>NvimTreeToggle<CR>", "NvimTree: Toggle")
        end,
    },
}
