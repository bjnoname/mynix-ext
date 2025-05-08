local substitute = require("substitute")

substitute.setup()

-- set keymaps
local keymap = vim.keymap -- for conciseness

-- substitute
keymap.set("n", "s", substitute.operator, { desc = "Substitute with motion" })
keymap.set("n", "ss", substitute.line, { desc = "Substitute line" })
keymap.set("n", "S", substitute.eol, { desc = "Substitute to end of line" })
keymap.set("x", "s", substitute.visual, { desc = "Substitute in visual mode" })

-- substitute range
keymap.set("n", "<leader>s", require('substitute.range').operator, { noremap = true })
keymap.set("x", "<leader>s", require('substitute.range').visual, { noremap = true })
keymap.set("n", "<leader>ss", require('substitute.range').word, { noremap = true })

-- exchange
keymap.set("n", "sx", require('substitute.exchange').operator, { noremap = true })
keymap.set("n", "sxx", require('substitute.exchange').line, { noremap = true })
keymap.set("x", "X", require('substitute.exchange').visual, { noremap = true })
keymap.set("n", "sxc", require('substitute.exchange').cancel, { noremap = true })
