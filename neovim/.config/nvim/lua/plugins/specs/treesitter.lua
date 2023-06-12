local M = {
  "nvim-treesitter/nvim-treesitter",
  dependencies = { "RRethy/nvim-treesitter-textsubjects", "windwp/nvim-ts-autotag" },
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
    textsubjects = {
      enable = true,
      prev_selection = ',', -- (Optional) keymap to select the previous selection
      keymaps = {
        ['.'] = 'textsubjects-smart',
        [';'] = 'textsubjects-container-outer',
        ['i;'] = 'textsubjects-container-inner',
      },
    },
  })

  require('nvim-ts-autotag').setup()
end

return M
