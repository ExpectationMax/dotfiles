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
