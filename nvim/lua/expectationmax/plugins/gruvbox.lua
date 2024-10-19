return {
    "ellisonleao/gruvbox.nvim",
    enabled=false,
    lazy=false,
    priority=1000,
    config = function()
        vim.o.background = "light"
        vim.cmd.colorscheme("gruvbox")
    end
}
