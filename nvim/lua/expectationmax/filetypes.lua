-- Git windows from nvr
vim.env.GIT_EDITOR = "nvr --remote-wait"
local gitGrp = vim.api.nvim_create_augroup("CloseGit", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "gitcommit", "gitrebase", "gitconfig" },
    command = "silent! set bufhidden=wipe",
    group = gitGrp,
})

-- Teminal without numbers, larger scrollback and in insert mode
local termGrp = vim.api.nvim_create_augroup("Terminal", { clear = true })
vim.api.nvim_create_autocmd("TermOpen", {
    callback = function(buf)
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
        vim.opt_local.signcolumn = "no"
        vim.opt_local.scrolloff = 0
        vim.bo.scrollback = 10000

        vim.keymap.set("n", "gf", function()
            local line = vim.fn.getline(".")
            -- Try both patterns:
            local file, lineno = line:match("([%w%._%+/%-]+%.%w+):(%d+)")
            if not file then
                -- File "/Users/rsdenijs/stagecraft/examples/chat_with_tools.py", line 153
                file, lineno = line:match("([%w%._%+/%-]+%.%w+)\",%s*line%s*(%d+)")
            end
            if not file then
                file = line:match("([%w%._%+/%-]+%.%w+)")
            end

            if file then
                local picked_window_id = require('window-picker').pick_window() or vim.api.nvim_get_current_win()
                vim.api.nvim_set_current_win(picked_window_id)
                vim.cmd("edit " .. file)
                if lineno then
                    vim.cmd(lineno)
                end
            else
                print("No file path found in line")
            end
        end, { buffer = true, desc = "Go to error file from terminal" })
    end,
    group = termGrp
})

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
      vim.highlight.on_yank({ timeout = 200 })
  end,
})
