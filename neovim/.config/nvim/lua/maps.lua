local function map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- go to init.lua
map('n', '<leader>v', ':e $MYVIMRC<CR>')

-- set relative numbers
map('n', '<C-n>', ':set relativenumber!<CR>')

-- toggle between panes more easily
map('n', '<C-j>', '<C-W><C-j>')
map('n', '<C-k>', '<C-W><C-k>')
map('n', '<C-l>', '<C-W><C-l>')
map('n', '<C-h>', '<C-W><C-h>')

-- tab works on visual selections
map('x', '<', '<gv')
map('x', '>', '>gv')

-- pressing esc removes highlighting
map('n', '<esc>', ':noh<return><esc>')

-- fzf search files
map('n', '<c-P>', "<cmd>lua require('fzf-lua').files()<CR>")
map('n', '<c-F>', "<cmd>lua require('fzf-lua').live_grep_glob()<CR>")
