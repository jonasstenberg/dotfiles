local M = {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-project.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  tag = "0.1.1",
  keys = {
    { "<C-p>", "<cmd>Telescope find_files<CR>", desc = "Find files" },
    { "<C-f>", "<cmd>Telescope live_grep<CR>",  desc = "Find grep" },
  },
  cmd = "Telescope",
}

function M.config()
  local telescope = require('telescope')

  telescope.setup {
    defaults = {
      mappings = {
        i = {
          ["<Esc>"] = require('telescope.actions').close
        }
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
        additional_args = function(_)
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
