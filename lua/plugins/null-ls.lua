local status_ok, null_ls = pcall(require, "null-ls")
if not status_ok then
	return
end

null_ls.setup({
	null_ls.builtins.formatting.stylua,
	null_ls.builtins.diagnostics.eslint,
	null_ls.builtins.diagnostics.tsc,
	-- General
	null_ls.builtins.completion.spell,
	-- Python
	null_ls.builtins.diagnostics.pylint,
	null_ls.builtins.formatting.autopep8

})
