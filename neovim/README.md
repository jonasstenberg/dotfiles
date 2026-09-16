# Neovim

[Repository setup](../README.md#setup)

The editor config is [LazyVim](https://www.lazyvim.org) with a small set of
overrides in [`.config/nvim/lua/plugins/`](.config/nvim/lua/plugins/).
Extras are enabled in [lazy.lua](.config/nvim/lua/config/lazy.lua).
Picker, explorer and terminal come from snacks.nvim;
completion from blink.cmp; Claude Code is integrated through the `ai.claudecode`
extra (`<leader>a`). Language servers and formatters are installed by mason on
first launch. Some installers require Node.js and npm on `PATH`. The shared
Zsh configuration loads NVM before launching `nvim` when NVM is installed.
NVM is included in the macOS `Brewfile`; install it separately on Fedora
or provide Node.js and npm yourself.

## Markdown preview

Open a Markdown file and press `Space c p` to toggle a live preview in your
default browser. You can also use `:MarkdownPreview`, `:MarkdownPreviewStop`,
or `:MarkdownPreviewToggle`. The preview updates as you edit and scroll.

Lazy installs [markdown-preview.nvim](https://github.com/iamcco/markdown-preview.nvim)
on first launch and downloads its standalone server, so previewing does not
require Node.js or Yarn. If that download fails, run
`:Lazy build markdown-preview.nvim` to retry.
