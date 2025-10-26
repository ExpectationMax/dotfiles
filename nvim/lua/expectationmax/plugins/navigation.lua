return {
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        ---@type Flash.Config
        opts = {
            modes = {
                char = {
                    enabled = false
                }
            }
        },
        -- stylua: ignore
        keys = {
          { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
          { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
          { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
          { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
          { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
        },
    },

    { 
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim"
        },
        keys={
            {"<C-S-n>", function() require("harpoon"):list():next() end, desc = "Harpoon next"},
            {"<C-S-p>", function() require("harpoon"):list():prev() end, desc = "Harpoon previous"},
            {"<C-S-m>", function() require("harpoon"):list():add() end, desc = "Harpoon mark"},
            {"<C-S-h>", function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end, desc = "Harpoon ui (help)"},
        },
        opts={
            settings = {
                save_on_toggle = true,
            }
        },
    }
}
