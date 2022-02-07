-- aliases
local cmd = vim.cmd
local fn = vim.fn
local g = vim.g
local opt = vim.opt

-- set leader key to space
vim.g.mapleader = ' '

if vim.g.vscode then
  require 'settings'
  cmd 'runtime! vimscript/**' -- load all vimscript files
else
  -- autoinstall packer.nvim if not already installed
  local install_path = fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system { 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path }
    vim.cmd 'packadd packer.nvim'
  end

  -- load my vim settings
  require 'settings'

  -- load maps
  require 'maps'

  -- load all of my packer plugins
  require 'plugins'
end
