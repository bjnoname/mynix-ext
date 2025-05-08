local neotest_ns = vim.api.nvim_create_namespace("neotest")
vim.diagnostic.config({
	virtual_text = {
		format = function(diagnostic)
			local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
			return message
		end,
	},
}, neotest_ns)

local neotest = require("neotest")
neotest.setup({
	adapters = {
		require("neotest-go"),
		require("neotest-jest"),
		require("rustaceanvim.neotest"),
	},
})

-- Set neotest keymap
local neotest_augroup = vim.api.nvim_create_augroup("neotest", { clear = true })

vim.api.nvim_create_autocmd({ "VimEnter" }, {
	group = neotest_augroup,
	callback = function()
		local set_keymap = function(keys, func, desc)
			vim.keymap.set("n", keys, func, { desc = "Test: " .. desc })
		end

		set_keymap("<leader>tt", function()
			neotest.run.run(vim.fn.expand("%"))
		end, "Run File")
		set_keymap("<leader>tT", function()
			neotest.run.run(vim.uv.cwd())
		end, "Run All Test Files")
		set_keymap("<leader>tr", function()
			neotest.run.run()
		end, "Run Nearest")
		set_keymap("<leader>tl", function()
			neotest.run.run_last()
		end, "Run Last")
		set_keymap("<leader>tS", function()
			neotest.run.stop()
		end, "Stop")
		set_keymap("<leader>ts", function()
			neotest.summary.toggle()
		end, "Toggles Summary")
		set_keymap("<leader>to", function()
			neotest.output.open({ enter = true, auto_close = true })
		end, "Show Output")
		set_keymap("<leader>tO", function()
			neotest.output_panel.toggle()
		end, "Toggle Output Panel")
		set_keymap("<leader>tw", function()
			neotest.watch.toggle(vim.fn.expand("%"))
		end, "Toggle Watch")
	end,
})
