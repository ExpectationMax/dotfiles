local fterm = require("FTerm")
fterm.setup({
    blend = 5
})
vim.keymap.set("n", "<C-CR>", fterm.toggle)
vim.keymap.set("t", "<C-CR>", fterm.toggle)
