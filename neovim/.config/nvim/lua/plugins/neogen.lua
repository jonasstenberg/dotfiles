local u = require("config.utils")

require("neogen").setup({
    enabled = true,
    languages = {
        lua = {
            template = {
                annotation_convention = "emmylua",
            },
        },
    },
})

u.nmap("<Leader>n", ":lua require'neogen'.generate()<CR>")
