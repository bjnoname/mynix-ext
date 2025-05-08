local conform = require("conform")

conform.setup({
	formatters_by_ft = {
		javascript = { "prettierd" },
		typescript = { "prettierd" },
		javascriptreact = { "prettierd" },
		typescriptreact = { "prettierd" },
		css = { "prettierd" },
		html = { "prettierd" },
		json = { "prettierd" },
		yaml = { "prettierd" },
		markdown = { "prettierd" },
		lua = { "stylua" },
		rust = { "rustfmt" },
		go = { "gofumpt", "goimports", "golines" },
		nix = { "nixpkgs_fmt" },
		["_"] = { "trim_whitespace" },
	},
	format_on_save = function(bufnr)
		if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
			return
		end
		return {
			lsp_fallback = true,
			async = false,
			timeout_ms = 1000,
		}
	end,
	notify_on_error = false,
})

vim.api.nvim_create_augroup("Format", { clear = true })
vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
	group = "Format",
	callback = function()
		vim.keymap.set({ "n", "v" }, "<leader>f", function()
			conform.format({
				lsp_fallback = true,
				async = false,
				timeout_ms = 1000,
			})
		end, { desc = "Format file or range (in visual mode)" })
	end,
})
