local cmp = require("cmp")

cmp.setup({
    completion = {
        completeopt = "menuone,noinsert",
    },
    snippet = {
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
        end,
    },
    mapping = {
        ["<C-Space>"] = cmp.mapping({ i = cmp.mapping.complete() }),
        ["<C-e>"] = cmp.mapping({ i = cmp.mapping.abort() }),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            else
                fallback()
            end
        end, {
            "i",
            "s",
        }),
    },
    sources = {
        { name = "nvim_lsp" },
        { name = "buffer" },
        { name = "path" },
        { name = "vsnip", priority = 9999 },
    },
})
