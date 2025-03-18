return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
        icons = {
            mappings = false,
            rules = false,
        },
        spec = {
            { "<leader>d", group = "[D]ebugger" },
            { "<leader>z", group = "[Z]ettelkasten" },
            { "<leader>g", group = "[G]it" },
            { "<leader>p", group = "[P]roject" },
            { "<leader>s", group = "[S]roject" },
        }
    },
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
}
