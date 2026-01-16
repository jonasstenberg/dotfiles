return {
  cmd = { "kotlin-lsp", "--stdio" },
  filetypes = { "kotlin" },
  -- For monorepos: find the nearest build.gradle (submodule) first,
  -- fall back to settings.gradle (root) only if no submodule found
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    -- First try to find nearest build.gradle (submodule level)
    local submodule_root = vim.fs.root(bufnr, { "build.gradle", "build.gradle.kts" })
    if submodule_root then
      return on_dir(submodule_root)
    end
    -- Fall back to project root
    local project_root = vim.fs.root(bufnr, { "settings.gradle", "settings.gradle.kts", ".git" })
    if project_root then
      return on_dir(project_root)
    end
  end,
}
