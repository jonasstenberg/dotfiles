return {
  'VonHeikemen/lsp-zero.nvim',
  branch = 'v2.x',
  dependencies = {
    -- LSP Support
    {
      'neovim/nvim-lspconfig', -- Required
      event = { "BufReadPre", "BufNewFile" },
      config = function()
        local lspconfig = require('lspconfig')

        require('mason').setup({})
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
      end
    },
    {
      'williamboman/mason.nvim', -- Optional
      build = ':MasonUpdate',
    },
    {
      'williamboman/mason-lspconfig.nvim' -- Optional
    },
    -- Autocompletion
    {
      'hrsh7th/nvim-cmp', -- Required
      event = 'InsertEnter',
      config = function()
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

        local cmp_action = require('lsp-zero').cmp_action()

        cmp.setup({
          mapping = {
            ['<Tab>'] = cmp_action.luasnip_supertab(),
            ['<S-Tab>'] = cmp_action.luasnip_shift_supertab(),
            ['<CR>'] = cmp.mapping.confirm({ select = false }),
          }
        })
      end,
      dependencies = {
        { "saadparwaiz1/cmp_luasnip" }
      }
    },
    {
      'hrsh7th/cmp-nvim-lsp' -- Required
    },
    {
      'L3MON4D3/LuaSnip', -- Required
      version = "1.*",
      dependencies = { "rafamadriz/friendly-snippets" },
      config = function()
        local luasnip = require("luasnip")
        luasnip.filetype_extend("javascript", { "html" })
        luasnip.filetype_extend("javascriptreact", { "html" })
        luasnip.filetype_extend("typescriptreact", { "html" })
        require("luasnip.loaders.from_vscode").lazy_load()
        -- require("luasnip.loaders.from_vscode").load({
        --   paths = {
        --     "~/.local/share/nvim/lazy/friendly-snippets" }
        -- })
      end,
      keys = function()
        return {}
      end,
    },
  },
  config = function()
    local lsp = require("lsp-zero")

    lsp.preset("recommended")

    lsp.ensure_installed({
      'tsserver',
    })

    -- Fix Undefined global 'vim'
    lsp.nvim_workspace()

    lsp.set_preferences({
      suggest_lsp_servers = false,
      sign_icons = {
        error = 'E',
        warn = 'W',
        hint = 'H',
        info = 'I'
      }
    })

    lsp.on_attach(function(_, bufnr)
      local opts = { buffer = bufnr, remap = false }

      vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
      vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
      vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
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
  end
}
