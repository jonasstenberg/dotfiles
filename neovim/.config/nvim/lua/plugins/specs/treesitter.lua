local M = {
  "nvim-treesitter/nvim-treesitter",
  dependencies = { "windwp/nvim-ts-autotag" },
  build = ":TSUpdate",
  event = "VeryLazy",
}

function M.config()
  require("nvim-treesitter.configs").setup({
    ensure_installed = {
      "query",
      "bash",
      "diff",
      "html",
      "make",
      "markdown",
      "lua",
      "json",
      "tsx",
      "javascript",
      "typescript",
      "vim",
      "vimdoc",
    },
    sync_install = false,
    auto_install = true,
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
  })

  require('nvim-ts-autotag').setup()
end

return M
