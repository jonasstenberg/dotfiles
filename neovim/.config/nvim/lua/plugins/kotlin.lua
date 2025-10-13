return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Disable kotlin_language_server - it's too buggy for monorepos
        kotlin_language_server = {
          enabled = false,
        },
      },
    },
  },
}
