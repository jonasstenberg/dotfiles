local M = {
  "tpope/vim-vinegar",
  event = "VeryLazy",
  config = function()
    vim.g.netrw_banner = false
    vim.g.netrw_liststyle = 3
  end
}

return M
