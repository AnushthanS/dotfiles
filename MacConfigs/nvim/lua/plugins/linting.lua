-- lua/plugins/linting.lua
return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lint = require("lint")
		lint.linters_by_ft = {
			c = { "cpplint" },
			cpp = { "cpplint" },
			python = { "ruff" },
			javascript = { "eslint_d" },
			typescript = { "eslint_d" },
			sh = { "shfmt" },
			make = { "checkmake" },
		}

		lint.linters.cpplint.args = {
			"--filter=-whitespace/line_length",
			"--linelength=120",
		}

		local lint_augroup = vim.api.nvim_create_augroup("Linting", { clear = true })
		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			group = lint_augroup,
			callback = function()
				lint.try_lint()
			end,
		})
	end,
}
