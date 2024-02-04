return {
    {
        "nvim-tree/nvim-tree.lua",
        event = "BufEnter",
        cmd = {
            "NvimTreeToggle",
            "NvimTreeOpen",
        },
        config = function()
            keymaps.nvim_tree_keymaps()

            local HEIGHT_RATIO = 0.8 -- You can change this
            local WIDTH_RATIO = 0.5 -- You can change this too

            require("nvim-tree").setup({
                disable_netrw = true,
                hijack_cursor = true,
                update_focused_file = { enable = true },
                diagnostics = {
                    enable = false,
                    show_on_dirs = true,
                    show_on_open_dirs = false,
                },
                modified = {
                    enable = true,
                    show_on_dirs = true,
                    show_on_open_dirs = false,
                },
                git = {
                    show_on_dirs = true,
                    show_on_open_dirs = false,
                },
                view = {
                    float = {
                        enable = true,
                        open_win_config = function()
                            local screen_w = vim.opt.columns:get()
                            local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
                            local window_w = screen_w * WIDTH_RATIO
                            local window_h = screen_h * HEIGHT_RATIO
                            local window_w_int = math.floor(window_w)
                            local window_h_int = math.floor(window_h)
                            local center_x = (screen_w - window_w) / 2
                            local center_y = ((vim.opt.lines:get() - window_h) / 2) - vim.opt.cmdheight:get()
                            return {
                                border = "rounded",
                                relative = "editor",
                                row = center_y,
                                col = center_x,
                                width = window_w_int,
                                height = window_h_int,
                            }
                        end,
                    },
                    width = function()
                        return math.floor(vim.opt.columns:get() * WIDTH_RATIO)
                    end,
                },
                renderer = {
                    highlight_modified = "icon",
                    indent_markers = {
                        enable = true,
                    },
                },
                actions = {
                    open_file = {
                        quit_on_open = true,
                    },
                },
            })
        end,
    },
}
