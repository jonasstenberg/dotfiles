local u = require("config.utils")

local api = vim.api

local split = function(direction)
    vim.cmd("wincmd " .. direction)
    return api.nvim_get_current_win()
end

-- make global to make ex commands easier
_G.inspect = function(...)
    print(vim.inspect(...))
end

local commands = {}

-- like vsplit, but reuses existing splits
api.nvim_add_user_command("Vsplit", function(opts)
    local file = opts.args ~= "" and opts.args or vim.fn.expand("%")

    local current_window = api.nvim_get_current_win()
    -- check for right split
    local split_window = split("l")
    -- no right split; check for left split
    if split_window == current_window then
        split_window = split("h")
    end

    -- no left or right split
    if split_window == current_window then
        vim.cmd("vsplit " .. file)
        return
    end

    local bufnr = vim.fn.bufadd(file)
    api.nvim_win_set_buf(split_window, bufnr)
end, {
    nargs = 1,
    complete = "file",
})

-- same but for split
api.nvim_add_user_command("Split", function(opts)
    local file = opts.args ~= "" and opts.args or vim.fn.expand("%")

    local current_window = api.nvim_get_current_win()
    local split_window = split("k")
    if split_window == current_window then
        split_window = split("j")
    end

    -- no left or right split
    if split_window == current_window then
        vim.cmd("split " .. file)
        return
    end

    local bufnr = vim.fn.bufadd(file)
    api.nvim_win_set_buf(split_window, bufnr)
end, {
    nargs = 1,
    complete = "file",
})

-- cmd should be in the form of "edit $FILE",
-- where $FILE is replaced with the found file's name
commands.edit_test_file = function(cmd)
    cmd = cmd or "edit"
    if not cmd:find("$FILE") then
        cmd = cmd .. " $FILE"
    end

    local done = function(file)
        vim.cmd(cmd:gsub("$FILE", file))
    end

    local root, ft = vim.pesc(vim.fn.expand("%:t:r")), vim.bo.filetype

    local patterns = {}
    if ft == "lua" then
        table.insert(patterns, "_spec")
    elseif ft == "typescript" or ft == "typescriptreact" then
        table.insert(patterns, "%.test")
        table.insert(patterns, "%.spec")
    end

    local final_patterns = {}
    for _, pattern in ipairs(patterns) do
        -- go from test file to non-test file
        if root:match(pattern) then
            pattern = root:gsub(vim.pesc(pattern), "")
        else
            pattern = root .. pattern
        end
        -- make sure extension matches
        pattern = pattern .. "%." .. vim.fn.expand("%:e") .. "$"
        table.insert(final_patterns, pattern)
    end

    -- check buffers first
    for _, b in ipairs(vim.fn.getbufinfo({ buflisted = 1 })) do
        for _, pattern in ipairs(final_patterns) do
            if b.name:match(pattern) then
                done(b.name)
                return
            end
        end
    end

    local scandir = function(path, depth, next)
        require("plenary.scandir").scan_dir_async(path, {
            depth = depth,
            search_pattern = final_patterns,
            on_exit = vim.schedule_wrap(function(found)
                if found[1] then
                    done(found[1])
                    return
                end

                if not next then
                    u.warn("test_file: corresponding file not found for file " .. vim.fn.expand("%:t"))
                    return
                end

                next()
            end),
        })
    end

    -- check same dir files first, then cwd
    scandir(vim.fn.expand("%:p:h"), 1, function()
        scandir(vim.fn.getcwd(), 5)
    end)
end

api.nvim_add_user_command("TestFile", function(opts)
    commands.edit_test_file(opts.args)
end, {
    complete = "command",
    nargs = 1,
})

u.nmap("<Leader>tv", function()
    commands.edit_test_file("Vsplit")
end)

commands.open_on_github = function(count, start_line, end_line)
    local remote = u.get_system_output("git remote -v")[1]
    if remote == "" or remote:find("fatal") then
        u.warn("not in a git repo")
        return
    end
    local username, repo = remote:match(":(%S+)/(%S+)%.")
    if not (username and repo) then
        u.warn("failed to get repo info")
        return
    end

    local branch = u.get_system_output("git rev-parse --abbrev-ref --symbolic-full-name HEAD")[1]
    if branch == "HEAD" then
        branch = u.get_system_output("git rev-parse HEAD")[1]
    end
    local repo_root = u.get_system_output("git rev-parse --show-toplevel")[1] .. "/"
    local path = api.nvim_buf_get_name(0):gsub(vim.pesc(repo_root), "")

    local url = table.concat({ "https://github.com", username, repo, "blob", branch, path }, "/")
    if count > 0 then
        local line_template = start_line == end_line and "#L%d" or "#L%d-L%d"
        url = url .. string.format(line_template, start_line, end_line)
    end

    vim.fn.system("open " .. url)
end

api.nvim_add_user_command("GBrowse", function(opts)
    global.commands.open_on_github(opts.count, opts.line1, opts.line2)
end, {
    range = true,
})

global.commands = commands

-- misc
u.command("Bonly", '%bdelete | edit # | normal `"')
u.command("Bdelete", "%bdelete")

u.command("Git", "tabnew term://lazygit")
u.nmap("<Leader>g", ":Git<CR>")

-- delete current file and buffer
u.command("Remove", "call delete(expand('%')) | bdelete")

-- get help for word under cursor
u.command("Help", 'execute ":help" expand("<cword>")')

-- reset treesitter and lsp diagnostics
u.command("R", "w | :e")

return commands
