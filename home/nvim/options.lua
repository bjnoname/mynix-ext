-- Set leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Add numbers to each line on the left-hand side.
vim.opt.number = true
vim.opt.relativenumber = true

-- Cursor line.
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- Tabs & indentation
vim.opt.tabstop = 2 -- 2 spaces for tabs (prettier default)
vim.opt.shiftwidth = 2 -- 2 spaces for indent width
vim.opt.expandtab = true -- expand tab to spaces
vim.opt.autoindent = true -- copy indent from current line when starting new one

-- Spellchecker config.
vim.opt.spell = true
vim.opt.spelllang = "en_us"

-- Search settings.
vim.opt.ignorecase = true -- ignore case when searching
vim.opt.smartcase = true -- if you include mixed case in your search, assumes you want case-sensitive

-- Colors
vim.opt.termguicolors = true

-- Clipboard
vim.opt.clipboard:append("unnamedplus") -- use system clipboard as default register

-- Split windows
vim.opt.splitright = true -- split vertical window to the right
vim.opt.splitbelow = true -- split horizontal window to the bottom

-- Timeout settings
vim.opt.timeout = true
vim.opt.timeoutlen = 500

-- Preview substitutions live, as you type!
vim.opt.inccommand = "split"
