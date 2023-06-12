local M = {
  "RRethy/vim-illuminate",
  event = "VeryLazy",
}

function M.config()
  local illuminate = require("illuminate")

  illuminate.configure({
    delay = 100,
  })
end

return M
