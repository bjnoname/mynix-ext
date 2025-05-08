local lint = require("lint")

lint.linters_by_ft = {
	javascript = { "eslint_d", "typos" },
	typescript = { "eslint_d", "typos" },
	javascriptreact = { "eslint_d", "typos" },
	typescriptreact = { "eslint_d", "typos" },
	python = { "ruff", "typos" },
	go = { "golangcilint", "typos" },
	rust = { "typos" },
}

local lint_augroup = vim.api.nvim_create_augroup("Lint", { clear = true })

vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
	group = lint_augroup,
	callback = function()
		lint.try_lint()
	end,
})
