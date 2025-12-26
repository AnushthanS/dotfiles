-- lua/plugins/mason.lua
return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
	},
	config = function()
		local mason = require("mason")
		local mason_lspconfig = require("mason-lspconfig")

		-- We will now tell mason itself what to install.
		-- This is more direct and avoids name translation issues.
		mason.setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
			-- This is the important change. We list the Mason package names here.
			ensure_installed = {
				-- LSPs (use Mason package names)
				"lua-language-server", -- was lua_ls
				"pyright",
				"typescript-language-server", -- was tsserver
				"vim-language-server", -- was vimls
				"terraform-ls", -- was terraformls
				"sql-language-server", -- was sqlls
				"dockerfile-language-server", -- was dockerls
				"json-lsp", -- was jsonls
				"jdtls",
				"graphql-language-service-cli", -- was graphql
				"yaml-language-server", -- was yamlls
				"cmakels", -- was cmake
				"marksman",
				"bash-language-server", -- was bashls
				"css-lsp", -- was cssls
				"html-lsp", -- was html
				"clangd",
				"lemminx",
				"rust-analyzer",

				-- Linters & Formatters
				"stylua",
				"prettier",
				"ruff",
				"checkmake",
				"eslint_d",
				"shfmt",
				"cpplint",
				"clang-format",
			},
		})

		-- Now, mason-lspconfig's only job is to connect the installed LSPs to lspconfig.
		-- It doesn't need its own ensure_installed list.
		mason_lspconfig.setup({
			-- This setting ensures that mason-lspconfig will automatically set up any LSPs
			-- that are installed via mason.nvim.
			automatic_installation = true,
		})
	end,
}
