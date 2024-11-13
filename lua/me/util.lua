local M = {}
-- Function that sets the colorscheme based on vim.o.background
-- light_theme: string
-- dark_theme: string
function M.set_colorscheme(light_theme, dark_theme)
    if vim.o.background == "dark" then
        vim.cmd.colorscheme(dark_theme)
    else
        vim.cmd.colorscheme(light_theme)
    end

    vim.api.nvim_create_autocmd({ "OptionSet" }, {
        pattern = { "background" },
        callback = function(_)
            if vim.o.background == "dark" then
                vim.cmd.colorscheme(dark_theme)
            else
                vim.cmd.colorscheme(light_theme) -- builtin theme
            end
            vim.cmd("mode") -- force a full redraw:
        end,
    })
end

return M
