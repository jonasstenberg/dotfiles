return {
  {
    "mfussenegger/nvim-dap",
    optional = true,
    dependencies = {
      {
        "mason-org/mason.nvim",
        opts = function(_, opts)
          opts.ensure_installed = opts.ensure_installed or {}
          vim.list_extend(opts.ensure_installed, { "js-debug-adapter" })
        end,
      },
    },
    opts = function()
      local dap = require("dap")

      -- Get the path to js-debug-adapter
      local js_debug_path = vim.fn.stdpath("data") .. "/mason/bin/js-debug-adapter"

      -- Setup pwa-chrome adapter
      if not dap.adapters["pwa-chrome"] then
        dap.adapters["pwa-chrome"] = {
          type = "server",
          host = "localhost",
          port = "${port}",
          executable = {
            command = js_debug_path,
            args = { "${port}" },
          },
        }
      end

      -- Add chrome adapter as alias to pwa-chrome
      if not dap.adapters["chrome"] then
        dap.adapters["chrome"] = dap.adapters["pwa-chrome"]
      end

      -- Setup pwa-node adapter for completeness
      if not dap.adapters["pwa-node"] then
        dap.adapters["pwa-node"] = {
          type = "server",
          host = "localhost",
          port = "${port}",
          executable = {
            command = js_debug_path,
            args = { "${port}" },
          },
        }
      end
    end,
  },
}
