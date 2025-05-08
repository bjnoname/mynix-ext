local nvim_lsp = require("lspconfig")

local telescope = require("telescope.builtin")

vim.o.updatetime = 250

--- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noselect"

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local attack_keymap = function(client, bufnr)
	local function buf_set_option(...)
		vim.api.nvim_buf_set_option(bufnr, ...)
	end

	local buf_set_keymap = function(keys, func, desc)
		vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
	end

	-- Disable LSP highlighting
	client.server_capabilities.semanticTokensProvider = nil

	-- Enable completion triggered by <c-x><c-o>
	buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

	-- Jump to the definition of the word under your cursor.
	--  This is where a variable was first declared, or where a function is defined, etc.
	--  To jump back, press <C-t>.
	buf_set_keymap("gd", telescope.lsp_definitions, "[G]oto [D]efinition")

	-- Find references for the word under your cursor.
	buf_set_keymap("gr", telescope.lsp_references, "[G]oto [R]eferences")

	-- Jump to the implementation of the word under your cursor.
	--  Useful when your language has ways of declaring types without an actual implementation.
	buf_set_keymap("gI", telescope.lsp_implementations, "[G]oto [I]mplementation")

	-- Jump to the type of the word under your cursor.
	--  Useful when you're not sure what type a variable is and you want to see
	--  the definition of its *type*, not where it was *defined*.
	buf_set_keymap("<leader>D", telescope.lsp_type_definitions, "Type [D]efinition")

	-- Fuzzy find all the symbols in your current document.
	--  Symbols are things like variables, functions, types, etc.
	buf_set_keymap("<leader>ds", telescope.lsp_document_symbols, "[D]ocument [S]ymbols")

	-- Fuzzy find all the symbols in your current workspace.
	--  Similar to document symbols, except searches over your entire project.
	buf_set_keymap("<leader>ws", telescope.lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

	-- Rename the variable under your cursor.
	--  Most Language Servers support renaming across files, etc.
	buf_set_keymap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")

	-- Execute a code action, usually your cursor needs to be on top of an error
	-- or a suggestion from your LSP for this to activate.
	buf_set_keymap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

	-- Opens a popup that displays documentation about the word under your cursor
	--  See `:help K` for why this keymap.
	buf_set_keymap("K", vim.lsp.buf.hover, "Hover Documentation")

	-- WARN: This is not Goto Definition, this is Goto Declaration.
	--  For example, in C this would take you to the header.
	buf_set_keymap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
end

local attach_diagnostics_popup = function(client, bufnr)
	-- The following two autocommands are used to setup diagnostic popup window
	local function open_diagnostic_popup()
		local popup_opts = {
			focusable = false,
			close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
			border = "rounded",
			source = "always",
			prefix = " ",
			scope = "cursor",
		}
		vim.diagnostic.open_float(nil, popup_opts)
	end

	vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
		buffer = bufnr,
		group = vim.api.nvim_create_augroup("diagnostic-cursor", { clear = true }),
		callback = open_diagnostic_popup,
	})

	-- The following two autocommands are used to highlight references of the
	-- word under your cursor when your cursor rests there for a little while.
	--    See `:help CursorHold` for information about when this is executed
	--
	-- When you move your cursor, the highlights will be cleared (the second autocommand).
	local lsp_client = vim.lsp.get_client_by_id(client.id)
	if lsp_client and lsp_client.server_capabilities.documentHighlightProvider then
		local cursor_augroup = vim.api.nvim_create_augroup("lsp-cursor", { clear = false })
		vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
			buffer = bufnr,
			group = cursor_augroup,
			callback = vim.lsp.buf.document_highlight,
		})

		vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
			buffer = bufnr,
			group = cursor_augroup,
			callback = vim.lsp.buf.clear_references,
		})

		vim.api.nvim_create_autocmd("LspDetach", {
			group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
			callback = function(event2)
				vim.lsp.buf.clear_references()
				vim.api.nvim_clear_autocmds({ group = cursor_augroup, buffer = event2.buf })
			end,
		})
	end
end

local on_attach = function(client, bufnr)
	attack_keymap(client, bufnr)

	attach_diagnostics_popup(client, bufnr)
end

-- The nvim-cmp almost supports LSP's capabilities so You should advertise it to LSP servers..
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches

local common_lsp_config = {
	on_attach = on_attach,
	capabilities = capabilities,
	flags = {
		ebounce_text_changes = 150,
	},
}

local servers = {
	bashls = {},
	nixd = {},
	html = {},
	cssls = {},
	pyright = {},
	ts_ls = {},
	clangd = {},
	dockerls = {},
	docker_compose_language_service = {},
	marksman = {},
	gopls = {},
	jsonls = {},
	yamlls = {},
	ltex_plus = {},
	zls = {},
	lua_ls = {
		on_init = function(client)
			local path = client.workspace_folders[1].name
			if not vim.loop.fs_stat(path .. "/.luarc.json") and not vim.loop.fs_stat(path .. "/.luarc.jsonc") then
				client.config.settings = vim.tbl_deep_extend("force", client.config.settings, {
					Lua = {
						runtime = {
							-- Tell the language server which version of Lua you're using
							-- (most likely LuaJIT in the case of Neovim)
							version = "LuaJIT",
						},
						-- Make the server aware of Neovim runtime files
						workspace = {
							checkThirdParty = false,
							library = {
								vim.env.VIMRUNTIME,
								-- "${3rd}/luv/library"
								-- "${3rd}/busted/library",
							},
							-- or pull in all of 'runtimepath'. NOTE: this is a lot slower
							-- library = vim.api.nvim_get_runtime_file("", true)
						},
					},
				})

				client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
			end
			return true
		end,
	},
}

for lsp, config in pairs(servers) do
	for k, v in pairs(common_lsp_config) do
		--- @diagnostic disable-next-line: assign-type-mismatch
		config[k] = v
	end
	nvim_lsp[lsp].setup(config)
end

-- rustaceanvim config
vim.g.rustaceanvim = {
	-- Plugin configuration
	tools = {
		float_win_config = {
			auto_focus = true,
		},
	},
	-- LSP configuration
	server = {
		on_attach = function(client, bufnr)
			attack_keymap(client, bufnr)

			attach_diagnostics_popup(client, bufnr)

			local buf_set_keymap = function(keys, func, desc)
				vim.keymap.set(
					"n",
					"<leader>R" .. keys,
					func,
					{ silent = true, buffer = bufnr, desc = "Rust: " .. desc }
				)
			end

			buf_set_keymap("a", function()
				vim.cmd.RustLsp("codeAction")
			end, "code actions")

			buf_set_keymap("K", function()
				vim.cmd.RustLsp({ "hover", "actions" })
			end, "hover actions")

			buf_set_keymap("r", function()
				vim.cmd.RustLsp("runnables")
			end, "runnables")

			buf_set_keymap("c", function()
				vim.cmd.RustLsp("openCargo")
			end, "open cargo")

			buf_set_keymap("e", function()
				vim.cmd.RustLsp({ "explainError", "current" })
			end, "explain error")

			buf_set_keymap("d", function()
				vim.cmd.RustLsp({ "renderDiagnostic", "current" })
			end, "render diagnostic")

			buf_set_keymap("u", function()
				vim.cmd.RustLsp("debuggables")
			end, "debuggables")
		end,
		default_settings = {
			-- rust-analyzer language server configuration
			["rust-analyzer"] = {},
		},
	},
	-- DAP configuration
	dap = {},
}
