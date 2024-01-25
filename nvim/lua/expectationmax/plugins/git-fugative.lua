return {
    "tpope/vim-fugitive",
    cmd = { "G", "Git", "GMove", "GDelete", "GRename" },
    keys = {
        {"<leader>gs", "<CMD>Git<cr>", desc = "Git status"},
        {"<leader>gc", "<CMD>Git commit<cr>", desc = "Git commit"},
        {"<leader>gu", "<CMD>Git push<cr>", desc = "Git push (upload)"},
        {"<leader>gd", "<CMD>Git pull<cr>", desc = "Git pull (download)"},
    }
}
