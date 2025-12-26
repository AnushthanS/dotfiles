-- lua/plugins/mason.lua
return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
	},
	config = function()
		local mason = require("mason")
		local mason_lspconfig = require("mason-lspconfig")
		local ensure = {
			-- LSPs
			"lua-language-server",
			"pyright",
			"typescript-language-server",
			"vim-language-server",
			"terraform-ls",
			"dockerfile-language-server",
			"json-lsp",
			"jdtls",
			"bqls",
			"graphql-language-service-cli",
			"yaml-language-server",
			"cmake-language-server",
			"marksman",
			"bash-language-server",
			"css-lsp",
			"html-lsp",
			"clangd",
			"lemminx",
			"rust-analyzer",

			-- Formatters / Linters
			"stylua",
			"prettier",
			"ruff",
			"checkmake",
			"eslint_d",
			"shfmt",
			"cpplint",

			-- DAP
			"cortex-debug",
		}
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
		})

		mason_lspconfig.setup({
			automatic_installation = true,
		})

		local mr = require("mason-registry")
		for _, pkg_name in ipairs(ensure) do
			local pkg = mr.get_package(pkg_name)
			if not pkg:is_installed() then
				pkg:install()
			end
		end
	end,
}
