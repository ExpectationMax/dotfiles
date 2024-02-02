return {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function(plugin, conf)
        require("tokyonight").setup(conf)
        vim.cmd.colorscheme("tokyonight-moon")
    end,
    opts = {
        dim_inactive = true
    }
 
}
