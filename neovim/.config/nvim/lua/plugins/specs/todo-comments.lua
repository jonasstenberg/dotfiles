local M = {
  "folke/todo-comments.nvim",
  enabled = true,
  dependencies = "nvim-lua/plenary.nvim",
  event = "VeryLazy",
}

function M.config()
  require("todo-comments").setup()
end

return M
