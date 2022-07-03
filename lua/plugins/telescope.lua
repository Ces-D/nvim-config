local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
  return
end

telescope.setup {
  defaults = {
  selection_caret = "> ",
  path_display= {"truncate"},
  selection_strategy= "reset",
  sorting_strategy="ascending",
  layout_strategy = "horizontal",

  layout_config = {
        horizontal = {
          prompt_position = "top",
          preview_width = 0.55,
          results_width = 0.8,
        },
        vertical = {
          mirror = false,
        },
        width = 0.87,
        height = 0.80,
        preview_cutoff = 120,
      },

    extensions = {
--     fzf = {
--      fuzzy = true,                    -- false will only do exact matching
--      override_generic_sorter = true,  -- override the generic sorter
--      override_file_sorter = true,     -- override the file sorter
--      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
--      }
    }
  }
}

-- telescope.load_extension('fzf')
-- telescope.load_extension('file_browser')
