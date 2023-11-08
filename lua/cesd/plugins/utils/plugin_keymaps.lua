local keymaps = {}
local map = vim.keymap.set

keymaps["lsp"] = function(ev)
    -- function sets up specific lsp keymaps
    map("n", "gD", vim.lsp.buf.declaration, { buffer = ev.buf, desc = "Go to LSP declaration" })
    -- map('n', 'gd', vim.lsp.buf.definition, { buffer = ev.buf, desc = "Go to LSP definitions" })
    map("n", "K", vim.lsp.buf.hover, { buffer = ev.buf, desc = "Open LSP hover menu" })
    map("n", "gi", vim.lsp.buf.implementation, { buffer = ev.buf, desc = "List all LSP implementation" })
    map({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, { buffer = ev.buf, desc = "LSP code action" })
    -- map('n', 'gr', vim.lsp.buf.references, { buffer = ev.buf, desc = "List all LSP references" })
    -- map('n', '<leader>fm', vim.lsp.buf.format, { buffer = ev.buf, desc = "LSP formatting" })
end

keymaps["conform"] = function()
    map("n", "<leader>fm", '<CMD>lua require("conform").format()<CR>', { desc = "LSP formatting" })
end

keymaps["telescope"] = function()
    map("n", "<leader>ff", "<cmd> Telescope find_files no-ignore=true hidden=true <CR>", { desc = "find files" })
    map(
        "n",
        "<leader>fa",
        "<cmd> Telescope find_files follow=true no_ignore=true hidden=true <CR>",
        { desc = "find all" }
    )
    map("n", "<leader>fw", "<cmd> Telescope live_grep <CR>", { desc = "find words" })
    map("n", "<leader>gr", "<cmd> Telescope lsp_references <CR>", { desc = "find references" })
    map("n", "<leader>fb", "<cmd> Telescope buffers <CR>", { desc = "find buffers" })
    map("n", "<leader>tk", "<cmd> Telescope keymaps <CR>", { desc = "show keys" })
    map("n", "<leader>gd", "<cmd> Telescope lsp_definitions <CR>", { desc = "find definitions" })
end

keymaps["cmp"] = function()
    local cmp = require("cmp")
    local t = function(str)
        return vim.api.nvim_replace_termcodes(str, true, true, true)
    end

    return {
        ["<CR>"] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace }),
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-w>"] = cmp.mapping.close(),
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif require("luasnip").expand_or_locally_jumpable() then
                vim.fn.feedkeys(t("<Plug>luasnip-expand-or-jump"))
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif require("luasnip").jumpable(-1) then
                vim.fn.feedkeys(t("<Plug>luasnip-jump-prev"), "")
            else
                fallback()
            end
        end, { "i", "s" }),
    }
end

keymaps["copilot"] = {
    accept = "<C-j>",
}

keymaps["nvim_tree_keymaps"] = function()
    map("n", "<leader>e", "<CMD>NvimTreeToggle<CR>", { silent = true, desc = "Toggle NvimTree" })
    map("n", "<leader>r", "<CMD>NvimTreeRefresh<CR>", { silent = true, desc = "Refresh NvimTree" })
end

return keymaps
