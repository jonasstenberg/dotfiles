local M = {
  "VonHeikemen/lsp-zero.nvim",
  event = "VeryLazy",
  branch = "v2.x",
}

function M.config()
  local lsp = require("lsp-zero")

  lsp.set_preferences({
    suggest_lsp_servers = false,
    sign_icons = {
      error = '✘',
      warn = '▲',
      hint = '⚑',
      info = '»',
    },
    float_border = 'rounded',
    call_servers = 'local',
    configure_diagnostics = true,
    setup_servers_on_start = true,
    set_lsp_keymaps = false,
    manage_nvim_cmp = {
      set_sources = 'lsp',
      set_basic_mappings = true,
      set_extra_mappings = false,
      use_luasnip = true,
      set_format = true,
      documentation_window = false,
    },
  })

  lsp.on_attach(function(_, bufnr)
    local opts = { buffer = bufnr, remap = false }

    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
    vim.keymap.set("n", "<leader>df", function() vim.diagnostic.goto_next() end, opts)
    vim.keymap.set("n", "<leader>ds", function() vim.diagnostic.goto_prev() end, opts)
    vim.keymap.set("n", "<leader>ca", function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
    vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)

    lsp.default_keymaps({ buffer = bufnr })
    lsp.buffer_autoformat()
  end)

  lsp.setup()

  vim.diagnostic.config({
    virtual_text = true
  })

  local lspconfig = require('lspconfig')

  require("mason").setup({})
  require("mason-lspconfig").setup({
    ensure_installed = {
      "bashls",
      "cssls",
      "html",
      "jsonls",
      "lua_ls",
      "tsserver",
    },
  })
  require('mason-lspconfig').setup_handlers({
    function(server)
      lspconfig[server].setup({})
    end,
  })

  local status_ok, npairs = pcall(require, "nvim-autopairs")
  if not status_ok then
    return
  end

  npairs.setup {
    check_ts = true,
    ts_config = {
      lua = { "string", "source" },
      javascript = { "string", "template_string" },
      java = false,
    },
    disable_filetype = { "TelescopePrompt", "spectre_panel" },
    fast_wrap = {
      map = "<M-e>",
      chars = { "{", "[", "(", '"', "'" },
      pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
      offset = 0, -- Offset from pattern match
      end_key = "$",
      keys = "qwertyuiopzxcvbnmasdfghjkl",
      check_comma = true,
      highlight = "PmenuSel",
      highlight_grey = "LineNr",
    },
  }

  local cmp_autopairs = require "nvim-autopairs.completion.cmp"
  local cmp_status_ok, cmp = pcall(require, "cmp")
  if not cmp_status_ok then
    return
  end
  cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done { map_char = { tex = "" } })

  local luasnip = require("luasnip")
  local cmp_action = require("lsp-zero").cmp_action()
  local kind_icons = require("plugins.specs.lsp-zero.icons")

  cmp.setup({
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body) -- For `luasnip` users.
      end,
    },
    mapping = {
      ['<Tab>'] = cmp_action.luasnip_supertab(),
      ['<S-Tab>'] = cmp_action.luasnip_shift_supertab(),
      ['<CR>'] = cmp.mapping.confirm({ select = false }),
    },
    formatting = {
      fields = { "kind", "abbr", "menu" },
      format = function(entry, vim_item)
        vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
        vim_item.menu = ({
          nvim_lsp = "[LSP]",
          nvim_lua = "[NVIM_LUA]",
          luasnip = "[Snippet]",
          buffer = "[Buffer]",
          path = "[Path]",
        })[entry.source.name]
        return vim_item
      end,
    },
    sources = {
      { name = "nvim_lsp" },
      { name = "nvim_lua" },
      { name = "luasnip" },
      { name = "buffer" },
      { name = "path" },
    },
  })
end

M.dependencies = { -- LSP Support
  { "neovim/nvim-lspconfig",            event = { "BufReadPre", "BufNewFile" } },
  { 'williamboman/mason.nvim',          build = ':MasonUpdate', },
  { "williamboman/mason-lspconfig.nvim" },
  -- Autocompletion
  { "hrsh7th/nvim-cmp",                 event = 'InsertEnter', },
  { "hrsh7th/cmp-nvim-lsp" },
  { "saadparwaiz1/cmp_luasnip" },
  {
    "L3MON4D3/LuaSnip",
    version = "1.*",
    dependencies = {
      "rafamadriz/friendly-snippets" },
  },
}

return M
