local M = {
  "RRethy/nvim-treesitter-endwise",
  event = "VeryLazy",
}

function M.config()
  require('nvim-treesitter.configs').setup {
    endwise = {
      enable = true,
    },
  }
end

return M
