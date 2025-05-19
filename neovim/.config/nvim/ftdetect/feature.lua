vim.filetype.add({
  extension = {
    feature = "feature",
  },
})

-- Disable treesitter for .feature files
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.feature",
  callback = function()
    vim.treesitter.stop()
    vim.bo.syntax = "feature"
  end,
})
