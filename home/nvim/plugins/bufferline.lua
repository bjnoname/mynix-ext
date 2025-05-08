require("bufferline").setup {
  options = {
    numbers = "buffer_id",
    separator_style = "slant",
    offsets = {
      {
        filetype = "NvimTree",
        text = "File Explorer",
        text_align = "left",
        separator = true,
      }
    },
    diagnostics = "nvim_lsp",
  }
}
