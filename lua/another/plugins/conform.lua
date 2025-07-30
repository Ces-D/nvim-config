return {
    {
        "stevearc/conform.nvim",
        event = { "BufReadPost" },
        config = function()
            local conform = require("conform")
            conform.setup({
                notify_on_error = true,
                formatters_by_ft = {
                    lua = { "stylua" },
                    python = { "isort", "black" },
                    javascript = { "eslint_d", "prettierd" },
                    typescript = { "eslint_d", "prettierd" },
                    typescriptreact = { "eslint_d", "prettierd", "rustywind" },
                    svelte = { "eslint_d", "prettierd", "rustywind" },
                    html = { "prettierd" },
                    json = { "jq" },
                    jsonc = { "jq" },
                    markdown = { "prettierd" },
                    rust = { "rustfmt" },
                    css = { "prettierd" },
                    scss = { "prettierd" },
                    bash = { "shfmt" },
                    sh = { "shfmt" },
                    toml = { "taplo" },
                    yaml = { "yamlfmt" },
                    sql = { "sqlfmt" },
                },
            })
            require("utils").map("<leader>fm", function()
                require("conform").format()
            end, "Format")
        end,
    },
}
