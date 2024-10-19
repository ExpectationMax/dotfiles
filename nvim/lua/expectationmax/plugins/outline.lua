return {
    "hedyhli/outline.nvim",
    lazy = true,
    cmd = { "Outline", "OutlineOpen" },
    keys = { -- Example mapping to toggle outline
        { "<leader>o", "<cmd>Outline<CR>", desc = "Toggle outline" },
    },
    opts = {
        symbols = {
            icon_source = 'lspkind',
            filter = {
                default = { 'String', exclude=true },
                python = { 'Function', 'Class' },
            },
        },
        preview_window = {
            winhl = 'NormalFloat:',
        },
    }
}
