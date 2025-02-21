return {
    {
        "MeanderingProgrammer/render-markdown.nvim",
        event = "BufEnter *.md",
        dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
        opts = {},
    },
}
