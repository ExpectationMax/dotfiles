-- Git windows from nvr
vim.env.GIT_EDITOR = "nvr -cc split --remote-wait"
local gitGrp = vim.api.nvim_create_augroup("CloseGit", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "gitcommit", "gitrebase", "gitconfig" },
    command = "silent! set bufhidden=delete",
    group = gitGrp,
})

-- Teminal without numbers, larger scrollback and in insert mode
local termGrp = vim.api.nvim_create_augroup("Terminal", { clear = true })
vim.api.nvim_create_autocmd("TermOpen", {
    callback = function(buf)
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
        vim.opt_local.signcolumn = "no"
        vim.bo.scrollback = 10000
    end,
    group = termGrp
})
