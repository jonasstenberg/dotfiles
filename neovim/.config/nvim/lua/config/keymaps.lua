-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
--
-- LazyVim already provides: <esc> clears search highlight, <A-j>/<A-k> move
-- lines, <C-h/j/k/l> window navigation (overridden by vim-tmux-navigator).

local map = vim.keymap.set

-- Live grep. Set here (VeryLazy) rather than in the snacks spec so it wins over
-- noice's <C-f> "scroll forward" mapping.
map("n", "<C-f>", function()
  Snacks.picker.grep()
end, { desc = "Live grep" })

-- Keep visual selection when indenting
map("x", "<", "<gv", { desc = "Indent left" })
map("x", ">", ">gv", { desc = "Indent right" })

-- Move selected lines with shift + j/k
map("x", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down", silent = true })
map("x", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up", silent = true })

-- Keep search matches centered
map("n", "n", "nzzzv", { desc = "Next match (centered)" })
map("n", "N", "Nzzzv", { desc = "Prev match (centered)" })

-- Paste over selection without clobbering the unnamed register
map("x", "<leader>p", '"_dP', { desc = "Paste (keep register)" })

-- Delete into the black hole register.
-- NOTE: <leader>d is also LazyVim's debug group when the dap extra is enabled,
-- so <leader>d in normal mode waits for which-key; visual mode is unaffected.
map({ "n", "x" }, "<leader>d", '"_d', { desc = "Delete (no register)" })

-- Swedish keyboard: å/ä as ^/$
map({ "n", "x", "o" }, "å", "^", { desc = "First non-blank" })
map({ "n", "x", "o" }, "ä", "$", { desc = "End of line" })
