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
            legacy_commands = false,
            workspaces = {
                {
                    name = "Tech",
                    path = "~/Documents/notes/Tech/",
                },
            },
            disable_frontmatter = true,
            completion = {
                blink = true,
                nvim_cmp = false,
            },
            picker = {
                name = "fzf-lua",
            },
        },
    },
}
