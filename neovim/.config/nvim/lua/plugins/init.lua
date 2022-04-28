return require('packer').startup(function(use)
    -- *i used the packer.nvim to manage the packer.nvim* - thanos
    use 'wbthomason/packer.nvim'

    local config = function(name)
        return string.format("require('plugins.%s')", name)
    end

    local use_with_config = function(path, name)
        use({ path, config = config(name) })
    end
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
    use_with_config("hrsh7th/vim-vsnip", "vsnip") -- snippets
    use({
    "hrsh7th/nvim-cmp", -- completion
    requires = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-vsnip",
    },
    config = config("cmp"),
    })
    use({
    "windwp/nvim-autopairs", -- autocomplete pairs
    config = config("autopairs"),
    wants = "nvim-cmp",
    })
    use_with_config("ibhagwan/fzf-lua", "fzf")
    use 'neovim/nvim-lspconfig'
    use 'b0o/schemastore.nvim'
    use 'folke/lua-dev.nvim'
    use 'nvim-lua/plenary.nvim'
    use 'jose-elias-alvarez/null-ls.nvim'
    use 'jose-elias-alvarez/nvim-lsp-ts-utils'
    use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
    }
    use_with_config('RRethy/vim-illuminate', 'illuminate')
    use_with_config('folke/trouble.nvim', 'trouble')

    -- treesitter
    use({
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    config = config("treesitter"),
    })
    use("RRethy/nvim-treesitter-textsubjects") -- adds smart text objects
    use("windwp/nvim-ts-autotag") -- automatically close jsx tags
    use("JoosepAlviste/nvim-ts-context-commentstring") -- makes jsx comments actually work
    use_with_config("mizlan/iswap.nvim", "iswap") -- interactively swap function arguments
    use_with_config("danymat/neogen", "neogen") -- annotation generator
    use("RRethy/nvim-treesitter-endwise") -- intelligently add end
end)
