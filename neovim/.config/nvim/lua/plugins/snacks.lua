-- snacks.nvim is LazyVim's default picker, explorer, notifier, terminal, etc.
-- This replaces the previous telescope.nvim setup with equivalent snacks pickers.
return {
  {
    "folke/snacks.nvim",
    opts = {
      explorer = {
        replace_netrw = true,
      },
      picker = {
        sources = {
          explorer = { hidden = true },
          files = { hidden = true },
          -- --hidden --no-ignore, matching the old telescope live_grep/grep_string setup
          grep = { hidden = true, ignored = true },
          grep_word = { hidden = true, ignored = true },
        },
      },
    },
    -- stylua: ignore
    keys = {
      { "<C-p>", function() Snacks.picker.files() end, desc = "Find files" },
      { "<C-t>", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer diagnostics" },
      { "<leader>fw", function() Snacks.picker.grep_word() end, desc = "Grep word under cursor", mode = { "n", "x" } },
      { "<leader>gb", function() Snacks.picker.git_branches() end, desc = "Git branches" },
      { "<leader>gc", function() Snacks.picker.git_log() end, desc = "Git commits" },
      { "<leader>bb", function() Snacks.picker.buffers() end, desc = "Buffers" },
      { "<leader>qf", function() Snacks.picker.qflist() end, desc = "Quickfix list" },
      { "<leader>ql", function() Snacks.picker.loclist() end, desc = "Location list" },
      { "<leader>hh", function() Snacks.picker.help() end, desc = "Help pages" },
      { "<leader>hm", function() Snacks.picker.man() end, desc = "Man pages" },
    },
  },
}
