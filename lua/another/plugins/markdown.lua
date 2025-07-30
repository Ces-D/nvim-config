return {
    {
        "obsidian-nvim/obsidian.nvim",
        version = "*", -- recommended, use latest release instead of latest commit
        lazy = true,
        ft = "markdown",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        opts = {
            workspaces = {
                {
                    name = "Tech",
                    path = "~/Documents/notes/Tech/",
                },
            },
            disable_frontmatter = true,
            completion = {
                nvim_cmp = true,
            },
            picker = {
                name = "fzf-lua",
            },
        },
    },
}
