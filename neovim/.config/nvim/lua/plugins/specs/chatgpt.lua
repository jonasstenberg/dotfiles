local M = {
  "jackMort/ChatGPT.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim"
  }
}

function M.config()
  require("chatgpt").setup({
    -- api_key_cmd = "op item get 'OpenAI' --fields label='API Key'"
  })
end

return M
