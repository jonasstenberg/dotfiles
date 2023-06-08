local null_ls = require("null-ls")
local b = null_ls.builtins

local with_diagnostics_code = function(builtin)
	return builtin.with({ diagnostics_format = "#{m} [#{c}]" })
end

local with_root_file = function(builtin, file)
	return builtin.with({
		condition = function(utils)
			return utils.root_has_file(file)
		end,
	})
end

local sources = {
	-- formatting
	b.formatting.prettierd,
	b.diagnostics.eslint_d.with({
		diagnostics_format = "[eslint] #{m}\n(#c{c})",
	}),
	-- b.formatting.eslint_d,
	-- b.formatting.djlint, -- HTML template linter and formatter
	-- b.formatting.shfmt,
	-- b.formatting.fixjson,
	-- b.formatting.gofmt, -- Formats go programs
	-- b.formatting.goimports, -- Updates your Go import lines, adding missing ones and removing unreferenced ones.
	b.formatting.stylua,
	-- b.formatting.trim_whitespace,
	-- b.formatting.trim_newlines,
	-- with_root_file(b.formatting.stylua, "stylua.toml"),
	-- -- diagnostics,
	-- with_root_file(b.diagnostics.selene, "selene.toml"),
	-- b.diagnostics.write_good,
	-- b.diagnostics.markdownlint,
	-- b.diagnostics.teal,
	b.diagnostics.tsc,
	with_diagnostics_code(b.diagnostics.shellcheck),
	-- -- code actions
	-- b.code_actions.gitsigns,
	-- b.code_actions.gitrebase,
	-- -- hover
	-- b.hover.dictionary,
}

local M = {}
M.setup = function(on_attach)
	null_ls.setup({
		-- debug = true,
		sources = sources,
		on_attach = on_attach,
	})
end

vim.api.nvim_create_user_command("DisableLspFormatting", function()
	vim.api.nvim_clear_autocmds({ group = augroup, buffer = 0 })
end, { nargs = 0 })

return M
