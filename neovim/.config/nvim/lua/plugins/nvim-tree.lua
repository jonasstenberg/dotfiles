local u = require("config.utils")

require("nvim-tree").setup({
	sort_by = "case_sensitive",
	view = {
		width = 30,
	},
	renderer = {
		group_empty = true,
	},
	filters = {
		dotfiles = false,
	},
})

u.nmap("<Leader>m", ":NvimTreeToggle<CR>")
