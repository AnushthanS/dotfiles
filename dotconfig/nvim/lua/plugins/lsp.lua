-- lua/plugins/lsp.lua
return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim", -- Ensures mason runs first
		{ "j-hui/fidget.nvim", opts = {} },
		"hrsh7th/cmp-nvim-lsp",
	},
	config = function()
		local on_attach = function(client, bufnr)
			local map = function(keys, func, desc)
				vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
			end

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

		local servers = {
			lua_ls = {
				settings = {
					Lua = {
						runtime = { version = "LuaJIT" },
						workspace = { checkThirdParty = false, library = vim.api.nvim_get_runtime_file("", true) },
						telemetry = { enable = false },
						diagnostics = { globals = { "vim" }, disable = { "missing-fields" } },
						format = { enable = false }, -- Let conform.nvim handle this
					},
				},
			},
			pyright = {
				settings = {
					python = {
						analysis = {
							autoSearchPaths = true,
							useLibraryCodeForTypes = true,
							diagnosticMode = "workspace",
						},
					},
				},
			},
			tsserver = {},
			vimls = {},
			terraformls = {},
			sqlls = {},
			dockerls = {},
			jsonls = {},
			jdtls = {},
			graphql = {},
			yamlls = {},
			cmake = {},
			marksman = {},
			bashls = {},
			cssls = {},
			html = {},
			clangd = {
				cmd = {
					"clangd",
					"--clangd-tidy",
					"--query-driver=/usr/bin/g++,/usr/bin/gcc",
					"--config-file=/home/anushthans/.config/nvim/.clangd",
				},
				filetypes = { "c", "cpp", "objc", "objcpp" },
				root_dir = function(fname)
					return require("lspconfig.util").root_pattern(
						"compile_commands.json",
						"compile_flags.txt",
						".git"
					)(fname)
				end,
			},
			lemminx = {},
			rust_analyzer = {},
		}

		for server_name, custom_opts in pairs(servers) do
			local server_opts = vim.tbl_deep_extend("force", {
				on_attach = on_attach,
				capabilities = capabilities,
			}, custom_opts or {})

			vim.lsp.config(server_name, server_opts)
		end
	end,
}
