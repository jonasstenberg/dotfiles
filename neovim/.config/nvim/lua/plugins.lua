return require('packer').startup(function(use)
  -- *i used the packer.nvim to manage the packer.nvim* - thanos
  use 'wbthomason/packer.nvim'

  -----------------------------------------------------
  ---
  --- lua plugins :D
  ---
  -----------------------------------------------------
  -- gruvbox color theme
  use 'ellisonleao/gruvbox.nvim'
  vim.cmd([[colorscheme gruvbox]])

  use 'tpope/vim-fugitive'
  use 'tpope/vim-surround'
  use 'tpope/vim-commentary'
  use 'tpope/vim-vinegar'
  use 'tpope/vim-endwise'
  use 'mhinz/vim-startify'
  use 'christoomey/vim-tmux-navigator'
  use 'kyazdani42/nvim-web-devicons'
  use 'ibhagwan/fzf-lua'
end)
