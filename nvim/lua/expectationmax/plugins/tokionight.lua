return {
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
}
