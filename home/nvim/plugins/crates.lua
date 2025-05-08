local crates = require("crates")

crates.setup({
	completion = {
		cmp = {
			enabled = true,
		},
	},
	on_attach = function()
		vim.keymap.set("n", "<leader>ct", crates.toggle, { desc = "Crates toggle" })
		vim.keymap.set("n", "<leader>cr", crates.reload, { desc = "Crates reload" })

		vim.keymap.set("n", "<leader>cv", crates.show_versions_popup, { desc = "Crates show versions" })
		vim.keymap.set("n", "<leader>cf", crates.show_features_popup, { desc = "Crates show features" })
		vim.keymap.set("n", "<leader>cd", crates.show_dependencies_popup, { desc = "Crates show dependencies" })

		vim.keymap.set("n", "<leader>cu", crates.update_crate, { desc = "Crate update" })
		vim.keymap.set("v", "<leader>cu", crates.update_crates, { desc = "Crate update" })
		vim.keymap.set("n", "<leader>ca", crates.update_all_crates, { desc = "All crates update" })
		vim.keymap.set("n", "<leader>cU", crates.upgrade_crate, { desc = "Crate upgrade" })
		vim.keymap.set("v", "<leader>cU", crates.upgrade_crates, { desc = "Crates upgrade" })
		vim.keymap.set("n", "<leader>cA", crates.upgrade_all_crates, { desc = "All crates upgrade" })

		vim.keymap.set(
			"n",
			"<leader>cx",
			crates.expand_plain_crate_to_inline_table,
			{ desc = "Expand plain crate into table" }
		)
		vim.keymap.set("n", "<leader>cX", crates.extract_crate_into_table, { desc = "Extract crate into table" })

		vim.keymap.set("n", "<leader>cH", crates.open_homepage, { desc = "Crate open homepage" })
		vim.keymap.set("n", "<leader>cR", crates.open_repository, { desc = "Crate open repository" })
		vim.keymap.set("n", "<leader>cD", crates.open_documentation, { desc = "Crate open documentation" })
		vim.keymap.set("n", "<leader>cC", crates.open_crates_io, { desc = "Open crate.io" })
	end,
})
