local M = {
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    grep = {
      rg_opts = "--hidden --column --line-number --no-heading --color=always --smart-case --no-ignore",
      rg_glob = nil,
    },
  },
  keys = {
    -- Find files
    { "<C-p>", "<cmd>FzfLua files<CR>",                desc = "Find files" },
    -- Show diagnostics
    { "<C-t>", "<cmd>FzfLua diagnostics_document<CR>", desc = "Show diagnostics" },
    -- Live grep
    { "<C-f>", "<cmd>FzfLua live_grep<CR>",            desc = "Search for a live string in all files" },
    -- grep word under cursor
    {
      "<leader>fw",
      function()
        require("fzf-lua").grep({
          search = vim.fn.expand("<cword>"),
          cwd = vim.fn.getcwd(), -- Search in the current project
        })
      end,
      desc = "Search for word under cursor in project"
    },
    -- Git branches
    { "<leader>gb", "<cmd>FzfLua git_branches<CR>", desc = "Git branches" },
    -- Git commits (project)
    { "<leader>gc", "<cmd>FzfLua git_commits<CR>",  desc = "Git commits (project)" },
    -- Git status
    { "<leader>gs", "<cmd>FzfLua git_status<CR>",   desc = "Git status" },
    -- Buffers
    { "<leader>bb", "<cmd>FzfLua buffers<CR>",      desc = "Buffers" },
    -- Tmux buffers
    { "<leader>tb", "<cmd>FzfLua tmux_buffers<CR>", desc = "Tmux sessions" },
    -- Quickfix list
    { "<leader>qf", "<cmd>FzfLua quickfix<CR>",     desc = "Quickfix list" },
    -- Loclist
    { "<leader>ql", "<cmd>FzfLua loclist<CR>",      desc = "Location list" },
    -- Help tags
    { "<leader>hh", "<cmd>FzfLua help_tags<CR>",    desc = "Help tags" },
    -- Man pages
    { "<leader>hm", "<cmd>FzfLua man_pages<CR>",    desc = "Man pages" },
  },
}

return M
