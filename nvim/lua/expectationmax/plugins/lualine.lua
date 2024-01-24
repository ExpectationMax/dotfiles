return {
    'nvim-lualine/lualine.nvim',
    dependencies = {
        {'nvim-tree/nvim-web-devicons', lazy = true },
        {'arkav/lualine-lsp-progress', lazy = true },
    },
    opts = {
        options = {
            theme = "gruvbox",
            globalstatus = true
        },
        sections = {
            lualine_c = {"lsp_progress"}
        }
    }
}
