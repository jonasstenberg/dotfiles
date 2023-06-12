local M = {
  'dinhhuy258/git.nvim',
}

local colorschemes = {
  base00 = '#16161D',
  base03 = '#565c64',
  base08 = '#e06c75',
  base0B = '#98c379',
  base0D = '#0184bc',
}

function M.config()
  local status, git = pcall(require, "git")
  if (not status) then return end

  git.setup({
    keymaps = {
      blame = "<Leader>gb",
      browse = "<Leader>go",
    },
    target_branch = "main",
  })

  vim.cmd(string.format("hi DiffAdd guifg = " .. colorschemes.base0B .. " guibg = " .. colorschemes.base00))
  vim.cmd(string.format("hi DiffChange guifg = " .. colorschemes.base03 .. " guibg = " .. colorschemes.base00))
  vim.cmd(string.format("hi DiffDelete guifg = " .. colorschemes.base08 .. " guibg = " .. colorschemes.base00))
  vim.cmd(string.format("hi DiffText guifg = " .. colorschemes.base0D .. " guibg = " .. colorschemes.base00))
  vim.cmd(string.format("hi DiffAdded guifg = " .. colorschemes.base0B .. " guibg = " .. colorschemes.base00))
  vim.cmd(string.format("hi DiffFile guifg = " .. colorschemes.base08 .. " guibg = " .. colorschemes.base00))
  vim.cmd(string.format("hi DiffNewFile guifg = " .. colorschemes.base0B .. " guibg = " .. colorschemes.base00))
  vim.cmd(string.format("hi DiffLine guifg = " .. colorschemes.base0D .. " guibg = " .. colorschemes.base00))
  vim.cmd(string.format("hi DiffRemoved guifg = " .. colorschemes.base08 .. " guibg = " .. colorschemes.base00))
end

return M
