local os = require("os")
local utils = require("expectationmax.utils")

vim.g.python3_host_prog = utils.path_join(os.getenv("HOME"), ".neovim_venv/bin/python3")

vim.env.GIT_EDITOR = "nvr -cc split --remote-wait"
local gitGrp = vim.api.nvim_create_augroup("CloseGit", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "gitcommit", "gitrebase", "gitconfig" },
    command = "silent! set bufhidden=delete",
    group = gitGrp,
})
