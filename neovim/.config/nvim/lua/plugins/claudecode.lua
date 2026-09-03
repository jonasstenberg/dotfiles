-- coder/claudecode.nvim is enabled via the lazyvim.plugins.extras.ai.claudecode extra
-- (see config/lazy.lua). It speaks the same protocol as the official VS Code
-- extension: diff accept/deny, send selection, add files. Default keys live
-- under <leader>a. This adds a quick toggle for muscle memory.
return {
  {
    "coder/claudecode.nvim",
    keys = {
      { "<C-,>", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude", mode = { "n", "t" } },
    },
  },
}
