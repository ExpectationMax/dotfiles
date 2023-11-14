return {
    "tpope/vim-fugitive",
    cmd = { "G", "Git", "GMove", "GDelete", "GRename" },
    keys = {
        {"<leader>gs", "<CMD>Git<cr>", desc = "Git status"},
        {"<leader>gc", "<CMD>Git commit<cr>", desc = "Git commit"}
    }
}
