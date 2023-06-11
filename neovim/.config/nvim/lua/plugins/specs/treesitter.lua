return {
  "nvim-treesitter/nvim-treesitter",
  config = function()
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
  end,
  dependencies = {
    "RRethy/nvim-treesitter-textsubjects"
  },
  build = ":TSUpdate",
  {
    "windwp/nvim-ts-autotag",
    config = function()
      require('nvim-ts-autotag').setup()
    end
  },
  {
    "RRethy/nvim-treesitter-textsubjects",
    config = function()
      require('nvim-treesitter.configs').setup({
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
    end,
  }
}
