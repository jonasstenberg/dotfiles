local M = {
  'sindrets/diffview.nvim',
}

function M.config()
  vim.opt.fillchars:append { diff = "╱" }

  local lib = require("diffview.lib")
  local diffview = require("diffview")

  toggle_status = function()
    local view = lib.get_current_view()
    if view == nil then
      diffview.open({});
      return
    end

    if view then
      view:close()
      lib.dispose_view(view)
    end
  end

  vim.keymap.set("n", "<leader>dv", function() toggle_status() end, { noremap = true })
end

return M
