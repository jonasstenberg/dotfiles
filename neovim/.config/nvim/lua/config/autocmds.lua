-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- LazyVim already provides: highlight on yank, resize splits on VimResized,
-- checktime on focus, auto-create parent dirs on save, last cursor location,
-- close helper windows with q, wrap+spell for text filetypes.

local function augroup(name)
  return vim.api.nvim_create_augroup("user_" .. name, { clear = true })
end

-- Trim trailing whitespace on save (keeps cursor/view in place, skips
-- filetypes where trailing whitespace is meaningful)
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup("trim_whitespace"),
  callback = function(event)
    local skip = { markdown = true, diff = true, gitcommit = true }
    if skip[vim.bo[event.buf].filetype] or vim.b[event.buf].no_trim_whitespace then
      return
    end
    local view = vim.fn.winsaveview()
    vim.cmd([[keeppatterns %s/\s\+$//e]])
    vim.fn.winrestview(view)
  end,
})
