return {
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "stylua", -- Lua formatter
        "prettier", -- JS/TS/JSON formatter
        "eslint_d", -- Fast ESLint
        "typescript-language-server", -- TypeScript LSP
        "kotlin-lsp", -- Kotlin LSP
      },
    },
  },
}
