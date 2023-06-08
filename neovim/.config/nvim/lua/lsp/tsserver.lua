local u = require("config.utils")

local ts_utils_settings = {
    -- debug = true,
    import_all_scan_buffers = 100,
    update_imports_on_move = true,
    -- filter out dumb module warning
    filter_out_diagnostics_by_code = { 80001 },
}

local M = {}
M.setup = function(on_attach, capabilities)
    local lspconfig = require("lspconfig")
    local ts_utils = require("nvim-lsp-ts-utils")

    lspconfig["tsserver"].setup({
        init_options = ts_utils.init_options,
        on_attach = function(client, bufnr)
            on_attach(client, bufnr)

            ts_utils.setup(ts_utils_settings)
            ts_utils.setup_client(client)

            u.buf_map(bufnr, "n", "gs", ":TSLspOrganize<CR>")
            u.buf_map(bufnr, "n", "gI", ":TSLspRenameFile<CR>")
            u.buf_map(bufnr, "n", "go", ":TSLspImportAll<CR>")
        end,
        filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
        cmd = { "typescript-language-server", "--stdio" },
        flags = {
            debounce_text_changes = 150,
        },
        capabilities = capabilities,
    })
end

return M
