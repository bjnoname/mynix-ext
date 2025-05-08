local telescope = require('telescope')
local actions = require("telescope.actions")

telescope.setup {
  defaults = {
    path_display = {
      filename_first = {
        reverse_directories = false
      }
    },
    mappings = {
      i = {
        ["<C-k>"] = actions.move_selection_previous, -- move to prev result
        ["<C-j>"] = actions.move_selection_next, -- move to next result
        ["<C-i>"] = actions.preview_scrolling_down, -- move to prev result
        ["<C-o>"] = actions.preview_scrolling_up, -- move to next result
        ["<C-u>"] = actions.preview_scrolling_left, -- move to prev result
        ["<C-p>"] = actions.preview_scrolling_right, -- move to next result
      },
    },
  },
  extensions = {
    fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
    }
  }
}

telescope.load_extension('fzf')

vim.keymap.set("n", "ff", "<cmd>Telescope find_files<cr>", { desc = "Telescope find files" })
vim.keymap.set("n", "fg", "<cmd>Telescope live_grep<cr>", { desc = "Telescope grep in files" })
vim.keymap.set("n", "fb", "<cmd>Telescope buffers<cr>", { desc = "Telescope show buffers" })
vim.keymap.set("n", "fh", "<cmd>Telescope help_tags<cr>", { desc = "Telescope help tags" })
vim.keymap.set("n", "fd", "<cmd>Telescope diagnostics<cr>", { desc = "Telescope show diagnostics" })
