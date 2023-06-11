return {
  "RRethy/vim-illuminate",
  config = function()
    local illuminate = require("illuminate")

    illuminate.configure({
      delay = 100,
    })
  end,
}
