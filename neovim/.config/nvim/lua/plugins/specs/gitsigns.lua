local M = {
  "lewis6991/gitsigns.nvim",
  event = "VeryLazy",
}

function M.config()
  require('gitsigns').setup()
end

return M
