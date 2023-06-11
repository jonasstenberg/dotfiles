local opt = vim.opt

vim.g.mapleader = " "
vim.g.maplocalleader = " "

opt.clipboard = "unnamedplus"

opt.mouse = "a"

opt.cmdheight = 1

opt.splitright = true
opt.splitbelow = true

opt.nu = true
opt.relativenumber = true

opt.cursorcolumn = true
opt.cursorline = true

opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smarttab = true

opt.smartindent = true

opt.ignorecase = true
opt.smartcase = true

opt.swapfile = false
opt.backup = false
opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
opt.undofile = true
opt.undolevels = 1000
opt.undoreload = 10000

opt.hlsearch = true
opt.incsearch = true

opt.termguicolors = true
vim.o.background = "dark"

opt.wrap = false

opt.colorcolumn = "80"

opt.updatetime = 50

opt.scrolloff = 8
opt.signcolumn = "yes"
