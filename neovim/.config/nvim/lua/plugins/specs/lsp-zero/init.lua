local M = {
  "VonHeikemen/lsp-zero.nvim",
  event = "VeryLazy",
  branch = "v2.x",
}

function M.config()
  -- Include the 'mason' bin directory in Neovim's PATH
  vim.env.PATH = vim.fn.stdpath('data') .. '/mason/bin' .. ':' .. vim.env.PATH

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

  lsp.on_attach(function(client, bufnr)
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
    -- lsp.buffer_autoformat() -- Removed to prevent conflict with formatter.nvim
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
      "ts_ls",
      "pyright",
    },
  })

  require('mason-lspconfig').setup_handlers({
    function(server)
      lspconfig[server].setup({})
    end,
    -- Disable formatting capabilities for tsserver to prevent conflicts
    ['ts_ls'] = function()
      lspconfig.ts_ls.setup({
        on_attach = function(client, bufnr)
          client.server_capabilities.documentFormattingProvider = false
        end,
        settings = {
          typescript = {
            inlayHints = {
              includeInlayParameterNameHints = 'all',
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayVariableTypeHintsWhenTypeMatchesName = false,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true
            },
            suggest = {
              includeCompletionsForModuleExports = true,
              includeCompletionsForImportStatements = true,
              autoImports = true
            }
          },
          javascript = {
            inlayHints = {
              includeInlayParameterNameHints = 'all',
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayVariableTypeHintsWhenTypeMatchesName = false,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true
            }
          }
        }
      })
    end,
    -- Disable formatting capabilities for pyright
    ['pyright'] = function()
      lspconfig.pyright.setup({
        on_attach = function(client, bufnr)
          client.server_capabilities.documentFormattingProvider = false
          -- You can keep other on_attach configurations here
        end,
      })
    end,
  })

  -- Setup mason-tool-installer to install external tools like eslint_d
  require('mason-tool-installer').setup({
    ensure_installed = {
      'eslint_d',
      'stylelint',
      'flake8',
      -- Add other tools you need
    },
    auto_update = false,
    run_on_start = true,
  })

  -- Autopairs configuration remains the same
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
      offset = 0,
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
        luasnip.lsp_expand(args.body)
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

  -- Configure formatter.nvim
  require('formatter').setup({
    logging = false,
    filetype = {
      javascript = {
        function()
          return {
            exe = "eslint_d",
            args = { "--fix", "--stdin", "--stdin-filepath", vim.api.nvim_buf_get_name(0) },
            stdin = true,
          }
        end,
      },
      typescript = {
        function()
          return {
            exe = "eslint_d",
            args = { "--fix", "--stdin", "--stdin-filepath", vim.api.nvim_buf_get_name(0) },
            stdin = true,
          }
        end,
      },
      python = {
        function()
          return {
            exe = "autopep8",
            args = { "-" },
            stdin = true,
          }
        end,
      },
      css = {
        function()
          return {
            exe = "stylelint",
            args = { "--fix", "--stdin", "--stdin-filename", vim.api.nvim_buf_get_name(0) },
            stdin = true,
            ignore_exitcode = true,
          }
        end,
      },
      -- Add other filetypes as needed
    },
  })

  -- Format on save
  vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = { "*.js", "*.jsx", "*.ts", "*.tsx", "*.css", "*.scss", "*.py" },
    command = "FormatWrite",
  })

  -- Configure nvim-lint
  local lint = require('lint')

  lint.linters_by_ft = {
    javascript = { 'eslint_d' },
    typescript = { 'eslint_d' },
    typescriptreact = { 'eslint_d' },
    javascriptreact = { 'eslint_d' },
    python = { 'flake8' },
    css = { 'stylelint' },
    -- Add other filetypes and linters as needed
  }

  -- Set the command path for eslint_d to use the one installed by mason
  lint.linters.eslint_d.cmd = vim.fn.stdpath('data') .. '/mason/bin/eslint_d'

  -- Lint on save and insert leave
  vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
    callback = function()
      require('lint').try_lint()
    end,
  })
end

M.dependencies = {
  -- LSP Support
  { "windwp/nvim-autopairs" },
  -- { "jose-elias-alvarez/null-ls.nvim" }, -- Removed null-ls
  { "neovim/nvim-lspconfig",                    event = { "BufReadPre", "BufNewFile" } },
  { 'williamboman/mason.nvim',                  build = ':MasonUpdate', },
  { "williamboman/mason-lspconfig.nvim" },
  { 'WhoIsSethDaniel/mason-tool-installer.nvim' }, -- Added mason-tool-installer
  -- Autocompletion
  { "hrsh7th/nvim-cmp",                         event = 'InsertEnter', },
  { "hrsh7th/cmp-nvim-lsp" },
  {
    "L3MON4D3/LuaSnip",
    version = "1.*",
    dependencies = {
      "rafamadriz/friendly-snippets",
      "saadparwaiz1/cmp_luasnip",
    },
  },
  -- Formatting and Linting
  { "mhartington/formatter.nvim" },
  { "mfussenegger/nvim-lint" },
}

return M
