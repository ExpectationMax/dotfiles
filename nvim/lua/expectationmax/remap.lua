vim.g.mapleader = " "

-- Navigation
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

vim.keymap.set("t", "<C-h>", "<C-\\><C-n><C-w>h")
vim.keymap.set("t", "<C-j>", "<C-\\><C-n><C-w>j")
vim.keymap.set("t", "<C-k>", "<C-\\><C-n><C-w>k")
vim.keymap.set("t", "<C-l>", "<C-\\><C-n><C-w>l")
vim.keymap.set("t", "<C-w>h", "<C-\\><C-n><C-w>h")
vim.keymap.set("t", "<C-w>j", "<C-\\><C-n><C-w>j")
vim.keymap.set("t", "<C-w>k", "<C-\\><C-n><C-w>k")
vim.keymap.set("t", "<C-w>l", "<C-\\><C-n><C-w>l")
vim.keymap.set("t", "<C-w>n", "<C-\\><C-n>")

-- vim.keymap.set("t", "gf", "<C-\\><C-n><C-w>v<C-w>Hgf:lua require('FTerm').toggle()<CR>")
-- vim.cmd("nnoremap gf &buftype==#'terminal' ? '<C-w>v<C-w>Hgf<C-w>l:lua require(\'FTerm\').toggle()<CR>' : 'gf'")


-- Disable ex mode
vim.keymap.set("n", "Q", "<Nop>")

-- Project management
vim.api.nvim_set_keymap("n", "<leader>pe", "", { desc = "Open explorer", callback = vim.cmd.Ex })
