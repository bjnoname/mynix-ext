require('scrollview').setup({
  excluded_filetypes = {'nerdtree'},
  base = 'right',
  signs_on_startup = {'all'},
  diagnostics_severities = {vim.diagnostic.severity.ERROR}
})

require('scrollview.contrib.gitsigns').setup()
