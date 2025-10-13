return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
    },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")

      telescope.setup({
        defaults = {
          file_ignore_patterns = { "^.git/" },
          mappings = {
            i = {
              ["<C-u>"] = false,
              ["<C-d>"] = false,
            },
          },
        },
        pickers = {
          find_files = {
            hidden = true,
          },
          live_grep = {
            additional_args = function()
              return { "--hidden", "--no-ignore" }
            end,
          },
          grep_string = {
            additional_args = function()
              return { "--hidden", "--no-ignore" }
            end,
          },
        },
      })

      -- Load fzf native extension for better performance
      pcall(telescope.load_extension, "fzf")
    end,
    keys = {
      -- Find files
      { "<C-p>", "<cmd>Telescope find_files<CR>", desc = "Find files" },
      -- Show diagnostics
      { "<C-t>", "<cmd>Telescope diagnostics bufnr=0<CR>", desc = "Show diagnostics" },
      -- Live grep
      { "<C-f>", "<cmd>Telescope live_grep<CR>", desc = "Search for a live string in all files" },
      -- Grep word under cursor
      {
        "<leader>fw",
        function()
          require("telescope.builtin").grep_string({ search = vim.fn.expand("<cword>") })
        end,
        desc = "Search for word under cursor in project",
      },
      -- Git branches
      { "<leader>gb", "<cmd>Telescope git_branches<CR>", desc = "Git branches" },
      -- Git commits (project)
      { "<leader>gc", "<cmd>Telescope git_commits<CR>", desc = "Git commits (project)" },
      -- Git status
      { "<leader>gs", "<cmd>Telescope git_status<CR>", desc = "Git status" },
      -- Buffers
      { "<leader>bb", "<cmd>Telescope buffers<CR>", desc = "Buffers" },
      -- Quickfix list
      { "<leader>qf", "<cmd>Telescope quickfix<CR>", desc = "Quickfix list" },
      -- Loclist
      { "<leader>ql", "<cmd>Telescope loclist<CR>", desc = "Location list" },
      -- Help tags
      { "<leader>hh", "<cmd>Telescope help_tags<CR>", desc = "Help tags" },
      -- Man pages
      { "<leader>hm", "<cmd>Telescope man_pages<CR>", desc = "Man pages" },
    },
  },
}
