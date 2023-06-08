local settings = {
    Lua = {
        diagnostics = {
            globals = {
                "global",
                "vim",
                "use",
                "describe",
                "it",
                "assert",
                "before_each",
                "after_each",
            },
        },
        completion = {
            showWord = "Disable",
            callSnippet = "Disable",
            keywordSnippet = "Disable",
        },
        workspace = {
            checkThirdParty = false,
            library = {
                ["${3rd}/love2d/library"] = true,
            },
        },
    },
}

local M = {}

M.setup = function(on_attach, capabilities)
    local luadev = require("neodev").setup({
    })
    require("lspconfig").lua_ls.setup({
        lspconfig = {
            on_attach = on_attach,
            settings = settings,
            flags = {
                debounce_text_changes = 150,
            },
            capabilities = capabilities,
        },
    })
end

return M
