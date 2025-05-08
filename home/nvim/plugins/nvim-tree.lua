require("nvim-tree").setup({
  sort = {
    sorter = "case_sensitive",
  },
  filters = {
    dotfiles = true,
  },
  actions = {
      open_file = {
        quit_on_open = true,
      },
  },
})

vim.keymap.set("n", "tt", "<cmd>NvimTreeToggle<cr>", { desc = "Open File explorer" })
