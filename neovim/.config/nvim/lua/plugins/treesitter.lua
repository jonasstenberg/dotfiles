return {
  {
    "nvim-treesitter/nvim-treesitter",
    -- LazyVim already installs bash, json, lua, markdown, toml, tsx, typescript, yaml, etc.
    -- opts_extend merges this list into the defaults.
    opts = {
      ensure_installed = {
        "kotlin",
        "sql",
      },
    },
  },
}
