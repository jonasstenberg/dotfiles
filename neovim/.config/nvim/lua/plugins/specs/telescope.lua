local M = {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-project.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "folke/trouble.nvim"
  },
  tag = "0.1.1",
  keys = {
    { "<C-p>", "<cmd>Telescope find_files<CR>",  desc = "Find files" },
    { "<C-f>", "<cmd>Telescope live_grep<CR>",   desc = "Find grep" },
    { "<C-t>", "<cmd>Telescope diagnostics<CR>", desc = "Show diagnostics" }
  },
  cmd = "Telescope",
}

function M.config()
  local actions = require("telescope.actions")
  local telescope = require('telescope')

  telescope.setup {
    defaults = {
      mappings = {
        i = {
          ["<Esc>"] = actions.close,
        },
      },
      prompt_prefix = " ",
      selection_caret = " ",
      file_ignore_patterns = {
        "^.git/",
      },
      wrap_results = false,
      dynamic_preview_title = true,
    },
    pickers = {
      find_files = {
        hidden = true
      },
      live_grep = {
        additional_args = function()
          return { "--hidden" }
        end
      },
    },
    extensions = {
      fzf = {
        fuzzy = true,                   -- false will only do exact matching
        override_generic_sorter = true, -- override the generic sorter
        override_file_sorter = true,    -- override the file sorter
        case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
      },
    },
  }
end

return M
