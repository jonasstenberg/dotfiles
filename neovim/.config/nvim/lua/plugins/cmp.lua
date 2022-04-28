local cmp = require("cmp")

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

cmp.setup({
    completion = {
        completeopt = "menuone,noinsert",
    },
    snippet = {
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
        end,
    },
    mapping = {
        ["<C-Space>"] = cmp.mapping({ i = cmp.mapping.complete() }),
        ["<C-e>"] = cmp.mapping({ i = cmp.mapping.abort() }),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
            end
        end, {
            "i",
            "s",
        }),
        ["<S-Tab>"] = cmp.mapping(function()
          if cmp.visible() then
            cmp.select_prev_item()
          end
        end, {
          "i",
          "s"
        }),
    },
    sources = {
        { name = "nvim_lsp" },
        { name = "buffer" },
        { name = "path" },
        { name = "vsnip", priority = 9999 },
    },
})
