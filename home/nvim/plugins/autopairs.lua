-- import nvim-autopairs
local autopairs = require("nvim-autopairs")

-- configure autopairs
autopairs.setup({
  check_ts = true, -- enable tree-sitter
  ts_config = {
    lua = { "string" }, -- don't add pairs in lua string tree-sitter nodes
    javascript = { "template_string" }, -- don't add pairs in JavaScript template_string tree-sitter nodes
    java = false, -- don't check tree-sitter on java
  },
})

-- import nvim-autopairs completion functionality
local cmp_autopairs = require("nvim-autopairs.completion.cmp")

-- import nvim-cmp plugin (completions plugin)
local cmp = require("cmp")

-- make autopairs and completion work together
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
