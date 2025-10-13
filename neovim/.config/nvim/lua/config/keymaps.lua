-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local function map(mode, lhs, rhs, opts)
  opts = opts or { noremap = true }
  opts.silent = opts.silent ~= false
  vim.keymap.set(mode, lhs, rhs, opts)
end

map("n", "<space>", "<nop>")

-- tab works on visual selections
map("x", "<", "<gv")
map("x", ">", ">gv")

-- pressing esc removes highlighting
map("n", "<esc>", ":noh<return><esc>")

-- move entire lines with shift + j/k
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")

-- kepe cursor in one place when jumping up and down
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

-- keep search in the middle
map("n", "N", "Nzzzv")
map("n", "n", "nzzzr")

-- paste and add new yank into void register
map("x", "<leader>p", '"_dP')

-- delete into void registry
map("n", "<leader>d", '"_d')
map("v", "<leader>d", '"_d')

map("n", "å", "^")
map("n", "ä", "$")
