local u = require("config.utils")

require("iswap").setup({
    autoswap = true,
})

u.nmap("<Leader>s", ":ISwapWith<CR>")
