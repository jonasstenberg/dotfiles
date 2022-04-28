require("nvim-treesitter.configs").setup({
    highlight = { enable = true },
    -- plugins
    autopairs = { enable = true },
    indent = {
      enable = true
    },
    context_commentstring = {
        enable = true,
        enable_autocmd = false,
    },
    textsubjects = {
        enable = true,
        keymaps = {
            ["."] = "textsubjects-smart",
            [";"] = "textsubjects-container-outer",
        },
    },
    autotag = { enable = true },
    endwise = { enable = true },
})
