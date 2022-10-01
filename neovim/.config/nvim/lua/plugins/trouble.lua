-- diagnostics
local u = require("config.utils")

require("trouble").setup {
  -- your configuration comes here
  -- or leave it empty to use the default settings
  -- refer to the configuration section below
}

u.nmap("<Leader>d", "<cmd>Trouble<cr>")
