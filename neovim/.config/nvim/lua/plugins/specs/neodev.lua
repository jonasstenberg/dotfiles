local M = {
  "folke/neodev.nvim",
  event = "VeryLazy",
  opts = {},
}

function M.config()
  require("neodev").setup({})

  local lspconfig = require('lspconfig')

  lspconfig.lua_ls.setup({
    settings = {
      Lua = {
        completion = {
          callSnippet = "Replace"
        },
        workspace = {
          checkThirdParty = false
        }
      }
    }
  })
end

return M
