local u = require("config.utils")

local lsp = vim.lsp

local border_opts = { border = "single", focusable = false, scope = "line" }

vim.diagnostic.config({ virtual_text = false, float = border_opts })

lsp.handlers["textDocument/signatureHelp"] = lsp.with(lsp.handlers.signature_help, border_opts)
lsp.handlers["textDocument/hover"] = lsp.with(lsp.handlers.hover, border_opts)

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

local lsp_formatting = function(bufnr)
  vim.lsp.buf.format({
    filter = function(client)
      return client.name == "null-ls"
    end,
    bufnr = bufnr,
  })
end

global.lsp = {
	border_opts = border_opts,
}

local on_attach = function(client, bufnr)
	-- commands
	u.command("LspFormat", vim.lsp.buf.format)
	u.command("LspHover", vim.lsp.buf.hover)
	u.command("LspRename", vim.lsp.buf.rename)
	u.command("LspDiagPrev", vim.diagnostic.goto_prev)
	u.command("LspDiagNext", vim.diagnostic.goto_next)
	u.command("LspDiagLine", vim.diagnostic.open_float)
	u.command("LspDiagQuickfix", vim.diagnostic.setqflist)
	u.command("LspSignatureHelp", vim.lsp.buf.signature_help)
	u.command("LspTypeDef", vim.lsp.buf.type_definition)
	u.command("LspAction", vim.lsp.buf.code_action)

	-- bindings
	u.buf_map(bufnr, "n", "<Leader>r", ":LspRename<CR>")
	u.buf_map(bufnr, "n", "gy", ":LspTypeDef<CR>")
	u.buf_map(bufnr, "n", "K", ":LspHover<CR>")
	u.buf_map(bufnr, "n", "<Leader>j", ":LspDiagPrev<CR>")
	u.buf_map(bufnr, "n", "<Leader>k", ":LspDiagNext<CR>")
	u.buf_map(bufnr, "n", "<Leader>a", ":LspDiagLine<CR>")
	u.buf_map(bufnr, "n", "<Leader>q", ":LspDiagQuickfix<CR>")
	u.buf_map(bufnr, "n", "<Leader>f", ":LspFormat<CR>")
	u.buf_map(bufnr, "i", "<C-x><C-x>", "<cmd> LspSignatureHelp<CR>")
	u.buf_map(bufnr, "n", "<Leader>i", ":LspAction<CR>")

	u.buf_map(bufnr, "n", "gr", ":LspRef<CR>")
	u.buf_map(bufnr, "n", "gd", ":LspDef<CR>")
	u.buf_map(bufnr, "n", "ga", ":LspAct<CR>")


  if client.supports_method("textDocument/formatting") then
    vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = augroup,
      buffer = bufnr,
      callback = function()
        lsp_formatting(bufnr)
      end,
    })
  end

	require("illuminate").on_attach(client)
end

local capabilities = require("cmp_nvim_lsp").default_capabilities()

for _, server in ipairs({
	"bashls",
	"denols",
	"eslint",
	"jsonls",
	"null-ls",
	"lua_ls",
	"tsserver",
	"gopls",
}) do
	-- require('lspconfig')["lsp" .. server].setup(on_attach, capabilities)
	require("lsp." .. server).setup(on_attach, capabilities)
end

-- suppress lspconfig messages
local notify = vim.notify
vim.notify = function(msg, ...)
	if msg:match("%[lspconfig%]") then
		return
	end

	notify(msg, ...)
end
