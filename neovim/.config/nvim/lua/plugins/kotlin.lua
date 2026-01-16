return {
  -- Enable the JetBrains kotlin-lsp (config in after/lsp/kotlin_lsp.lua)
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        kotlin_lsp = {
          mason = false, -- installed via homebrew, not mason
        },
      },
    },
  },
  -- Treesitter for Kotlin syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "kotlin" },
    },
  },
  {
    "saghen/blink.cmp",
    optional = true,
    opts = {
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
        providers = {
          lsp = {
            enabled = true,
          },
        },
      },
    },
  },
}
