return {
  {
    "iamcco/markdown-preview.nvim",
    lazy = true,
    ft = "markdown",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = function()
      -- Download the standalone preview server; no Node.js or Yarn required.
      require("lazy").load({ plugins = { "markdown-preview.nvim" } })
      vim.fn["mkdp#util#install"]()
    end,
    keys = {
      { "<leader>cp", "<cmd>MarkdownPreviewToggle<cr>", ft = "markdown", desc = "Markdown Preview" },
    },
    config = function()
      -- Register buffer-local commands when loaded from a command or keybinding.
      vim.cmd("do FileType")
    end,
  },
}
