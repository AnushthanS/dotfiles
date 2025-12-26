-- lua/plugins/formatting.lua
return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "ruff_format" },
			javascript = { "prettier" },
			typescript = { "prettier" },
			html = { "prettier" },
			json = { "prettier" },
			yaml = { "prettier" },
			markdown = { "prettier" },
			sh = { "shfmt" },
			c = { "clang_format" },
			cpp = { "clang_format" },
			terraform = { "terraform_fmt" },
		},
		formatters = {
			shfmt = {
				args = { "-i", "4" },
			},
		},
		format_on_save = {
			timeout_ms = 500,
			lsp_fallback = true, -- Fallback to LSP formatting if no conform formatter is found
		},
	},
	keys = {
		{ "<leader>lf", function() require("conform").format({ async = true, lsp_fallback = true }) end, mode = "n", desc = "Format buffer" },
	},
}
