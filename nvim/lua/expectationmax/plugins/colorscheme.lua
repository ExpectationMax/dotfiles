return {
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        config = function(plugin, conf)
            require("tokyonight").setup(conf)
            vim.cmd.colorscheme("tokyonight")
        end,
        opts = {
            dim_inactive = true,
            style = "moon",
            light_style = "day",
            day_brightness = 0.1,
        }
    },

    {
        "ellisonleao/gruvbox.nvim",
        enabled=false,
        lazy=false,
        priority=1000,
        config = function()
            vim.o.background = "light"
            vim.cmd.colorscheme("gruvbox")
        end
    }
}
