return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.1",
  config = function()
    require('telescope').setup {
      defaults = {
        mappings = {
          i = {
            ["<C-h>"] = "which_key",
            ["<Esc>"] = require('telescope.actions').close
          }
        }
      },
      pickers = {
        find_files = {
          hidden = true
        },
        live_grep = {
          additional_args = function(_)
            return { "--hidden" }
          end
        },
      },
      extensions = {
        -- Your extension configuration goes here:
        -- extension_name = {
        --   extension_config_key = value,
        -- }
        -- please take a look at the readme of the extension you want to configure
      },
    }
  end,
  keys = {
    { "<C-p>", "<cmd>Telescope find_files<CR>", desc = "Find files" },
    { "<C-f>", "<cmd>Telescope live_grep<CR>",  desc = "Find grep" },
  },
  cmd = "Telescope",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-lua/plenary.nvim",
  },
}
