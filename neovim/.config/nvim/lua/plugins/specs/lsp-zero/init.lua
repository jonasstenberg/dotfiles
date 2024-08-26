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
    configure_diagnostics = false,
    float_border = 'rounded',
    call_servers = 'local',
    setup_servers_on_start = true,
    set_lsp_keymaps = false,
    manage_nvim_cmp = {
      set_sources = 'lsp',
      set_basic_mappings = true,
      set_extra_mappings = false,
      use_luasnip = true,
      set_format = true,
      documentation_window = true,
    },
  })

  lsp.on_attach(function(_, bufnr)
    local opts = { buffer = bufnr, remap = false }

    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set("n", "gr", function() vim.lsp.buf.references() end, opts)
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set("n", "<leader>df", function() vim.diagnostic.goto_next() end, opts)
    vim.keymap.set("n", "<leader>ds", function() vim.diagnostic.goto_prev() end, opts)
    vim.keymap.set("n", "<leader>ca", function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set("n", "rn", function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)

    vim.api.nvim_create_autocmd("CursorHold", {
      buffer = bufnr,
      callback = function()
        local lopts = {
          focusable = false,
          close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
          border = 'rounded',
          source = 'always',
          prefix = ' ',
          scope = 'cursor',
        }
        vim.diagnostic.open_float(nil, lopts)
      end
    })

    lsp.default_keymaps({ buffer = bufnr })
    lsp.buffer_autoformat()
  end)

  lsp.setup()

  vim.diagnostic.config({
    virtual_text = false,
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
      "pyright",
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
  luasnip.filetype_extend("python", { "py" })
  luasnip.filetype_extend("javascript", { "html" })
  luasnip.filetype_extend("javascriptreact", { "html" })
  luasnip.filetype_extend("typescriptreact", { "html" })
  require("luasnip.loaders.from_vscode").lazy_load()

  local cmp_action = require("lsp-zero").cmp_action()
  local kind_icons = require("plugins.specs.lsp-zero.icons")
  local function border(hl_name)
    return {
      { "╭", hl_name },
      { "─", hl_name },
      { "╮", hl_name },
      { "│", hl_name },
      { "╯", hl_name },
      { "─", hl_name },
      { "╰", hl_name },
      { "│", hl_name },
    }
  end

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
    window = {
      completion = {
        scrollbar = false,
      },
      documentation = {
        side_padding = 1,
        border = border "CmpDocBorder",
      },
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

  local null_ls = require("null-ls")

  null_ls.setup({
    sources = {
      null_ls.builtins.formatting.prettier,
      null_ls.builtins.formatting.autopep8,
      null_ls.builtins.diagnostics.stylelint,
      null_ls.builtins.formatting.stylelint,
      null_ls.builtins.code_actions.eslint_d
    },
  })
end

M.dependencies = { -- LSP Support
  { "windwp/nvim-autopairs" },
  { "jose-elias-alvarez/null-ls.nvim" },
  { "neovim/nvim-lspconfig",            event = { "BufReadPre", "BufNewFile" } },
  { 'williamboman/mason.nvim',          build = ':MasonUpdate', },
  { "williamboman/mason-lspconfig.nvim" },
  -- Autocompletion
  { "hrsh7th/nvim-cmp",                 event = 'InsertEnter', },
  { "hrsh7th/cmp-nvim-lsp" },
  {
    "L3MON4D3/LuaSnip",
    version = "1.*",
    dependencies = {
      "rafamadriz/friendly-snippets",
      "saadparwaiz1/cmp_luasnip",
    },
  },
}

return M
