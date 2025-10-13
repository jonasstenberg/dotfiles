return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "bash",
        "javascript",
        "typescript",
        "tsx",
        "json",
        "kotlin",
        "lua",
        "markdown",
        "markdown_inline",
        "sql",
        "yaml",
        "toml",
      })
    end,
  },
}
