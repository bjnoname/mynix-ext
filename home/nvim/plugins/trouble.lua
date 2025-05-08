local trouble = require("trouble")

trouble.setup({})

local neotest_augroup = vim.api.nvim_create_augroup("trouble", { clear = true })

vim.api.nvim_create_autocmd({ "VimEnter" }, {
	group = neotest_augroup,
	callback = function()
		local set_keymap = function(keys, func, desc)
			vim.keymap.set("n", keys, func, { desc = "Trouble: " .. desc })
		end

		set_keymap("<leader>xd", function()
			trouble.toggle("diagnostics")
		end, "diagnostics")
		set_keymap("<leader>xq", function()
			trouble.toggle("quickfix")
		end, "quickfix")
		set_keymap("<leader>xl", function()
			trouble.toggle("loclist")
		end, "loclist")
		set_keymap("gR", function()
			trouble.toggle("lsp_references")
		end, "LSP references")
	end,
})
