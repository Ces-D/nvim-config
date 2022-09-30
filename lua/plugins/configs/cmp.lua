local present, cmp = pcall(require, "nvim-cmp")
local snipPresent, luasnip = pcall(require, "luasnip")

if not (present and snipPresent) then
  return
end

  cmp.setup {
    window = {
      completion = {
        border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
      },
      documentation = {
        border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
      },
    },
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    mapping = {
      ["<C-p>"] = cmp.mapping.select_prev_item(),
      ["<C-n>"] = cmp.mapping.select_next_item(),
      ["<C-d>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<C-e>"] = cmp.mapping.close(),
      ["<CR>"] = cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Replace,
        select = false,
      },
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif require("luasnip").expand_or_jumpable() then
          vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true), "")
        else
          fallback()
        end
      end, {
        "i",
        "s",
      }),
      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif require("luasnip").jumpable(-1) then
          vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-jump-prev", true, true, true), "")
        else
          fallback()
        end
      end, {
        "i",
        "s",
      }),
    },
    sources = {
      { name = "luasnip" },
      { name = "nvim_lsp" },
      { name = "buffer" },
      { name = "nvim_lua" },
      { name = "path" },
    },
  }
