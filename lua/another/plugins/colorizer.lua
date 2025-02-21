return {
    {
        "NvChad/nvim-colorizer.lua",
        event = "BufEnter *.css,*.less,*.sass,*.scss,*.html",
        opts = {
            filetypes = {
                -- "svelte",
                -- "javascript",
                -- "typescript",
                -- "javascriptreact",
                -- "typescriptreact",
                "html",
                "css",
                "less",
                "sass",
                "scss",
                -- "lua",
                -- "json",
                -- "yaml",
                -- "toml",
                -- "md",
                -- "markdown",
            },
        },
    },
}
