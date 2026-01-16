return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = { eslint = {} },
      setup = {
        eslint = function()
          -- Enable formatting for eslint
          Snacks.util.lsp.on({ name = "eslint" }, function(_, client)
            client.server_capabilities.documentFormattingProvider = true
          end)
          -- Disable formatting for vtsls/tsserver (let eslint handle it)
          Snacks.util.lsp.on({ name = "vtsls" }, function(_, client)
            client.server_capabilities.documentFormattingProvider = false
          end)
        end,
      },
    },
  },
}
