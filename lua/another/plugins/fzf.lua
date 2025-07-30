return {
    {
        "ibhagwan/fzf-lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        event = "VeryLazy",
        opts = {},
        config = function()
            local map = require("utils").map
            map("<leader>e", function()
                require("fzf-lua").files({})
            end, "Fzf: Files")
            map("<leader>fg", function()
                require("fzf-lua").git_status()
            end, "Fzf: Git Files")
            map("<leader><leader>", function()
                require("fzf-lua").buffers()
            end, "Fzf: Buffers")
            map("<leader>fh", function()
                require("fzf-lua").help_tags()
            end, "Fzf: Help Tags")
            map("g/", function()
                require("fzf-lua").grep()
            end, "Fzf: Grep Current Word")
            map("/", function()
                require("fzf-lua").grep_curbuf()
            end, "Fzf: Grep Current Buffer")
            map("<leader>fk", function()
                require("fzf-lua").keymaps()
            end, "Fzf: Keymaps")
        end,
    },
}
