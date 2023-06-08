local prettier = require("prettier")

prettier.setup({
  bin = 'prettierd', -- or `'prettierd'` (v0.23.3+)
  filetypes = {
    "css",
    "html",
    "javascript",
    "javascriptreact",
    "json",
    "markdown",
    "typescript",
    "typescriptreact",
    "yaml",
  },
})
