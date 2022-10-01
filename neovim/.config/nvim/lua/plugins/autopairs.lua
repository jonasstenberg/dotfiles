-- auto...pairs?
local autopairs = require("nvim-autopairs")
local u = require("config.utils")

autopairs.setup({
    check_ts = true,
    fast_wrap = {
        map = "<M-e>",
    },
})

local disabled = false
local enable = function()
    autopairs.enable()
    disabled = false
end
local disable = function()
    autopairs.disable()
    disabled = true
end

global.toggle_autopairs = function()
    if disabled then
        enable()
        return
    end

    disable()
    vim.cmd("autocmd InsertLeave * ++once lua global.reset_autopairs()")
end

global.reset_autopairs = function()
    if disabled then
        enable()
    end
end

-- toggle pair completion
u.imap("<M-t>", "<cmd> lua global.toggle_autopairs()<CR>")
