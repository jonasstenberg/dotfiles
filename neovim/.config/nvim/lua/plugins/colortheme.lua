return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    opts = {
      flavour = "mocha",
      custom_highlights = function(colors)
        return {
          LineNr = { fg = colors.overlay1 }, -- Brighter line numbers
          CursorLineNr = { fg = colors.yellow, style = { "bold" } }, -- Bold yellow current line number
        }
      end,
    },
  },
  -- Let LazyVim apply the colorscheme (handles load order and reload correctly)
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "catppuccin-mocha" },
  },
}
