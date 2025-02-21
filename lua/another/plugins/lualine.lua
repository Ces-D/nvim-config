return {
    ---------- Lualine ----------
    {
        "nvim-lualine/lualine.nvim",
        lazy = true,
        event = { "VeryLazy" },
        opts = {
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
        },
    },
}
