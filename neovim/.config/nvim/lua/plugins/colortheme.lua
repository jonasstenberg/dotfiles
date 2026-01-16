local M = {
  "catppuccin/nvim",
  priority = 1000,
  config = function()
    require("catppuccin").setup({
      custom_highlights = function(colors)
        return {
          LineNr = { fg = colors.overlay1 }, -- Brighter line numbers
          CursorLineNr = { fg = colors.yellow, style = { "bold" } }, -- Bold yellow current line number
        }
      end,
    })
    vim.cmd.colorscheme("catppuccin-mocha")
  end,
}

return M
