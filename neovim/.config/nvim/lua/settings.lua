-- Aliases for Lua API functions
local o = vim.o
local opt = vim.opt

-- Enable syntax highlighting and filetype plugins
-- vim.cmd 'syntax enable'
-- vim.cmd 'filetype plugin on'

opt.clipboard = 'unnamed'
opt.completeopt = {'menu', 'menuone', 'noselect'}
opt.mouse = 'a'
opt.splitright = true
opt.splitbelow = true
opt.expandtab = true
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.smarttab = true
opt.number = true
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true
-- set diffopt+=vertical " starts diff mode in vertical split
opt.hidden = true
opt.cmdheight = 1
-- set shortmess+=c " don't need to press enter so often
opt.signcolumn = 'yes'
opt.updatetime = 520
opt.undofile = true
opt.undodir = "/tmp/vim/undo"
opt.undolevels = 1000
opt.undoreload = 10000
vim.cmd('filetype plugin indent on')
opt.backup = false

opt.relativenumber = true
vim.cmd(':set nu rnu')
opt.history = 200
opt.ruler = true
opt.cursorcolumn = true
opt.cursorline = true

opt.autoread = true
opt.updatecount = 0
opt.swapfile = true
opt.wrap = false
opt.termguicolors = true

vim.g.netrw_banner = false
vim.g.netrw_liststyle = 3
vim.g.markdown_fenced_languages = { 'javascript', 'js=javascript', 'json=javascript' }

vim.cmd('autocmd VimResized * wincmd =')

-- Autocmds
vim.cmd 'au! TextYankPost * lua vim.highlight.on_yank { on_visual = false }' -- highlight yank for a brief second for visual feedback

-- Trim trailing whitespace on save
vim.cmd[[ autocmd BufWritePre * :%s/\s\+$//e ]]

-- global mark I for last edit
vim.cmd [[autocmd InsertLeave * execute 'normal! mI']]

-- auto create parent dir
vim.cmd([[
augroup BWCCreateDir
    autocmd!
    autocmd BufWritePre * if expand("<afile>")!~#'^\w\+:/' && !isdirectory(expand("%:h")) | execute "silent! !mkdir -p ".shellescape(expand('%:h'), 1) | redraw! | endif
augroup END
]])

-- colorscheme global defaults
o.background = 'dark'
o.termguicolors = true
