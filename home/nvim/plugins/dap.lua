local dap = require("dap")
local dapui = require("dapui")

dapui.setup()

dap.listeners.before.attach.dapui_config = function()
	dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
	dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
	dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
	dapui.close()
end

local dap_augroup = vim.api.nvim_create_augroup("dap", { clear = true })

vim.api.nvim_create_autocmd({ "VimEnter" }, {
	group = dap_augroup,
	callback = function()
		local set_keymap = function(mode, keys, func, desc)
			vim.keymap.set(mode, keys, func, { desc = "DAP: " .. desc })
		end
		set_keymap("n", "<F5>", function()
			dap.continue()
		end, "continue")
		set_keymap("n", "<F10>", function()
			dap.step_over()
		end, "step over")
		set_keymap("n", "<F11>", function()
			dap.step_into()
		end, "set into")
		set_keymap("n", "<F12>", function()
			dap.step_out()
		end, "step out")
		set_keymap("n", "<leader>db", function()
			dap.toggle_breakpoint()
		end, "toggle breakpoint")
		set_keymap("n", "<leader>dB", function()
			dap.set_breakpoint()
		end, "set breakpoint")
		set_keymap("n", "<leader>dlp", function()
			dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
		end, "set breakpoint with message")
		set_keymap("n", "<leader>dr", function()
			dap.repl.open()
		end, "open repl")
		set_keymap("n", "<leader>dl", function()
			dap.run_last()
		end, "run last")
		set_keymap({ "n", "v" }, "<leader>dh", function()
			require("dap.ui.widgets").hover()
		end, "widget hover")
		set_keymap({ "n", "v" }, "<leader>dp", function()
			require("dap.ui.widgets").preview()
		end, "widget preview")
		set_keymap("n", "<leader>df", function()
			local widgets = require("dap.ui.widgets")
			widgets.centered_float(widgets.frames)
		end, "frames float")
		set_keymap("n", "<leader>ds", function()
			local widgets = require("dap.ui.widgets")
			widgets.centered_float(widgets.scopes)
		end, "scopes float")
		set_keymap({ "n", "v" }, "<leader>du", function()
			dapui.toggle()
		end, "toggle ui")
	end,
})
