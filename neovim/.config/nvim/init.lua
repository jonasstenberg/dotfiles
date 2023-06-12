require("config.options")
require("config.keymaps")
require("config.autocmds")

if vim.g.vscode then
  vim.cmd("runtime! vimscript/**")
else
  require("plugins")
end
