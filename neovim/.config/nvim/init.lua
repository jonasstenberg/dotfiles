-- aliases
local cmd = vim.cmd
local fn = vim.fn

-- set leader key to space
vim.g.mapleader = ' '

-- initialize global object for config
global = {}

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

    require('settings')
    require('config')
    require('plugins')
    require('lsp')
end
