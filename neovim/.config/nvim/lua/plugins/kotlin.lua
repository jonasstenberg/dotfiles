return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Disable kotlin_language_server - it's too buggy for monorepos
        kotlin_lsp = {},
      },
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
