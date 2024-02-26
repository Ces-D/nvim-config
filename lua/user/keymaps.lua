local nnoremap = require("user.utils").nnoremap
local vnoremap = require("user.utils").vnoremap
local inoremap = require("user.utils").inoremap
-- local tnoremap = require("user.keymap_utils").tnoremap
local xnoremap = require("user.utils").xnoremap

local require = require("user.utils").safe_require
local is_git_directory = require("user.utils").is_git_directory

-- Normal --
-- Disable Space bar since it'll be used as the leader key
nnoremap("<space>", "<nop>")

-- Save with leader key
nnoremap("<leader>w", "<cmd>w<cr>", { silent = true })

-- Quit with leader key
nnoremap("<leader>q", "<cmd>q<cr>", { silent = true })

-- Save and Quit with leader key
nnoremap("<leader>wq", "<cmd>wq<cr>", { silent = true })
local M = {}

-- Press leader f to format
nnoremap("<leader>fm", ":Format<cr>")

-- Center buffer while navigating
nnoremap("<C-u>", "<C-u>zz")
nnoremap("<C-d>", "<C-d>zz")
nnoremap("{", "{zz")
nnoremap("}", "}zz")
nnoremap("N", "Nzz")
nnoremap("n", "nzz")
nnoremap("G", "Gzz")
nnoremap("gg", "ggzz")
nnoremap("<C-i>", "<C-i>zz")
nnoremap("<C-o>", "<C-o>zz")
nnoremap("%", "%zz")
nnoremap("*", "*zz")
nnoremap("#", "#zz")

-- Press 'S' for quick find/replace for the word under the cursor
nnoremap("S", function()
    local cmd = ":%s/<C-r><C-w>/<C-r><C-w>/gI<Left><Left><Left>"
    local keys = vim.api.nvim_replace_termcodes(cmd, true, false, true)
    vim.api.nvim_feedkeys(keys, "n", false)
end)

-- Goto next diagnostic of any severity
nnoremap("]d", function()
    vim.diagnostic.goto_next({})
    vim.api.nvim_feedkeys("zz", "n", false)
end)

-- Goto previous diagnostic of any severity
nnoremap("[d", function()
    vim.diagnostic.goto_prev({})
    vim.api.nvim_feedkeys("zz", "n", false)
end)

-- Goto next error diagnostic
nnoremap("]e", function()
    vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
    vim.api.nvim_feedkeys("zz", "n", false)
end)

-- Goto previous error diagnostic
nnoremap("[e", function()
    vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
    vim.api.nvim_feedkeys("zz", "n", false)
end)

-- Move text up/down
nnoremap("<C-j>", ":m .+1<CR>==")
nnoremap("<C-k>", ":m .-2<CR>==")
vnoremap("<C-j>", ":m '>+1<CR>gv=gv")
vnoremap("<C-k>", ":m '<-2<CR>gv=gv")

-- Clear search results
nnoremap("<leader>h", "<CMD>nohlsearch<CR>")

-- Map NvimTree to <leader>e
nnoremap("<leader>e", function()
    require("oil").toggle_float()
end)

-- Harpoon keybinds --
-- Open harpoon ui
nnoremap("<leader>ho", function()
    require("harpoon").ui:toggle_quick_menu(require("harpoon"):list())
end)

-- Add current file to harpoon
nnoremap("<leader>ha", function()
    require("harpoon"):list():append()
end)

-- Quickly jump to harpooned files
nnoremap("<leader>1", function()
    require("harpoon"):list():select(1)
end)

nnoremap("<leader>2", function()
    require("harpoon"):list():select(2)
end)

nnoremap("<leader>3", function()
    require("harpoon"):list():select(3)
end)

nnoremap("<leader>4", function()
    require("harpoon"):list():select(4)
end)

nnoremap("<leader>5", function()
    require("harpoon"):list():select(5)
end)

-- Git keymaps --
nnoremap("<leader>gb", ":Gitsigns toggle_current_line_blame<cr>")
nnoremap("<leader>gf", function()
    local cmd = {
        "sort",
        "-u",
        "<(git diff --name-only --cached)",
        "<(git diff --name-only)",
        "<(git diff --name-only --diff-filter=U)",
    }

    if not is_git_directory() then
        vim.notify(
            "Current project is not a git directory",
            vim.log.levels.WARN,
            { title = "Telescope Git Files", git_command = cmd }
        )
    else
        require("telescope.builtin").git_files()
    end
end, { desc = "Search [G]it [F]iles" })

-- Telescope keybinds --
nnoremap("<leader>sb", require("telescope.builtin").buffers, { desc = "[S]earch Open [B]buffers" })
nnoremap("<leader>sf", function()
    require("telescope.builtin").find_files({ hidden = true })
end, { desc = "[S]earch [F]iles" })
nnoremap("<leader>sh", require("telescope.builtin").help_tags, { desc = "[S]earch [H]elp" })
nnoremap("<leader>sg", require("telescope.builtin").live_grep, { desc = "[S]earch by [G]rep" })

nnoremap("<leader>/", function()
    require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
        previewer = false,
    }))
end, { desc = "[/] Fuzzily search in current buffer]" })

-- LSP Keybinds (exports a function to be used in ../../after/plugin/lsp.lua b/c we need a reference to the current buffer) --
M.map_lsp_keybinds = function(buffer_number)
    nnoremap("<leader>rn", vim.lsp.buf.rename, { desc = "LSP: [R]e[n]ame", buffer = buffer_number })
    nnoremap("<leader>ca", vim.lsp.buf.code_action, { desc = "LSP: [C]ode [A]ction", buffer = buffer_number })

    nnoremap("<leader>gd", vim.lsp.buf.definition, { desc = "LSP: [G]oto [D]efinition", buffer = buffer_number })

    -- Telescope LSP keybinds --
    nnoremap(
        "<leader>gr",
        require("telescope.builtin").lsp_references,
        { desc = "LSP: [G]oto [R]references", buffer = buffer_number }
    )

    nnoremap(
        "<leader>gi",
        require("telescope.builtin").lsp_implementations,
        { desc = "LSP: [G]oto [I]mplementation", buffer = buffer_number }
    )

    nnoremap(
        "<leader>bs",
        require("telescope.builtin").lsp_document_symbols,
        { desc = "LSP: [B]buffer [S]symbols", buffer = buffer_number }
    )

    nnoremap(
        "<leader>ps",
        require("telescope.builtin").lsp_workspace_symbols,
        { desc = "LSP: [P]roject [S]symbols", buffer = buffer_number }
    )

    -- See `:help K` for why this keymap
    nnoremap("K", vim.lsp.buf.hover, { desc = "LSP: Hover Documentation", buffer = buffer_number })
    nnoremap("<leader>k", vim.lsp.buf.signature_help, { desc = "LSP: Signature Documentation", buffer = buffer_number })

    -- Lesser used LSP functionality
    nnoremap("gD", vim.lsp.buf.declaration, { desc = "LSP: [G]oto [D]eclaration", buffer = buffer_number })
    nnoremap("td", vim.lsp.buf.type_definition, { desc = "LSP: [T]ype [D]efinition", buffer = buffer_number })
end

-- Copilot keymaps --
M.copilot = {
    accept = "<C-j>",
}

-- Insert --
-- Map jj to <esc>
inoremap("jj", "<esc>")

-- Visual --
-- Disable Space bar since it'll be used as the leader key
vnoremap("<space>", "<nop>")

-- Reselect the last visual selection
xnoremap("<<", function()
    vim.cmd("normal! <<")
    vim.cmd("normal! gv")
end)

xnoremap(">>", function()
    vim.cmd("normal! >>")
    vim.cmd("normal! gv")
end)

return M
