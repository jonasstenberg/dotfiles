return {
  -- JetBrains kotlin-lsp, installed via Homebrew (server config in after/lsp/kotlin_lsp.lua).
  -- LazyVim's lang.kotlin extra uses the older fwcd kotlin_language_server, so we
  -- enable kotlin_lsp directly instead of importing that extra.
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        kotlin_lsp = {
          mason = false,
        },
      },
    },
  },
}
