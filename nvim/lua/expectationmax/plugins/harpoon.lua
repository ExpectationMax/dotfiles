return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim"
    },
    config = true,
    keys={
        {"<C-S-n>", function() require("harpoon"):list():next() end, desc = "Harpoon next"},
        {"<C-S-p>", function() require("harpoon"):list():prev() end, desc = "Harpoon previous"},
        {"<C-S-m>", function() require("harpoon"):list():append() end, desc = "Harpoon mark"},
        {"<C-S-h>", function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end, desc = "Harpoon ui (help)"},
    },
    opts={
        settings = {
            save_on_toggle = true,
        }
    },
}
