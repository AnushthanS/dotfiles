-- lua/plugins/lsp.lua
return {
	"neovim/nvim-lspconfig",
	dependencies = {
		-- These are now dependencies of nvim-lspconfig
		"williamboman/mason.nvim", 
		{ "j-hui/fidget.nvim", opts = {} },
		"hrsh7th/cmp-nvim-lsp",
	},
	config = function()
		-- This is your on_attach function, virtually unchanged.
		-- It's the function that will run every time a new LSP attaches to a buffer.
		local on_attach = function(client, bufnr)
			local map = function(keys, func, desc)
				vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
			end

			-- Your keymaps are preserved here
			map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
			map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
			map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
			map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
			map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
			map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
			map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
			map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
			map("K", vim.lsp.buf.hover, "Hover Documentation")
			map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
			map("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
			map("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
			map("<leader>wl", function()
				print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
			end, "[W]orkspace [L]ist Folders")

			if client and client.server_capabilities.documentHighlightProvider then
				local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
				vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
					buffer = bufnr,
					group = highlight_augroup,
					callback = vim.lsp.buf.document_highlight,
				})
				vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
					buffer = bufnr,
					group = highlight_augroup,
					callback = vim.lsp.buf.clear_references,
				})
			end
		end

		-- Setup LSP capabilities
		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		-- Get the lspconfig module
		local lspconfig = require("lspconfig")
		-- Get the servers from mason-lspconfig
		local servers = require("mason-lspconfig").get_installed_servers()

		-- Loop through the servers and set them up
		for _, server_name in ipairs(servers) do
			local server_opts = {
				on_attach = on_attach,
				capabilities = capabilities,
			}
			-- Add custom server configurations here
			if server_name == "lua_ls" then
				server_opts.settings = {
					Lua = {
						runtime = { version = "LuaJIT" },
						workspace = { checkThirdParty = false, library = vim.api.nvim_get_runtime_file("", true) },
						telemetry = { enable = false },
						diagnostics = { globals = { "vim" }, disable = { "missing-fields" } },
						format = { enable = false }, -- Let conform.nvim handle formatting
					},
				}
			end

			-- **Python recommendation**
			-- Use pyright for type checking and language features.
			-- Let ruff handle ALL linting and formatting.
			-- This is the modern, high-performance standard.
			if server_name == "pyright" then
				-- Pyright setup can be minimal as ruff handles the rest
				server_opts.settings = {
					python = {
						analysis = {
							autoSearchPaths = true,
							useLibraryCodeForTypes = true,
							diagnosticMode = "workspace",
						},
					},
				}
			end

			if server_name == "ruff" then
				-- B.: Do not setup ruff as an LSP server
			else
				lspconfig[server_name].setup(server_opts)
			end
		end
	end,
}
