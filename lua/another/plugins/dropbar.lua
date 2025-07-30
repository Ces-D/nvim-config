return {
    {
        "Bekaboo/dropbar.nvim",
        event = "BufReadPost",
        config = function()
            local dropbar_api = require("dropbar.api")
            local map = require("utils").map
            map("<Leader>;", dropbar_api.pick, "Dropbar: Pick symbols in winbar")
            map("[;", dropbar_api.goto_context_start, "Dropbar: Go to start of current context")
            map("];", dropbar_api.select_next_context, "Dropbar: Select next context")
        end,
    },
}
