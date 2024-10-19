return {
    "kwkarlwang/bufjump.nvim",
    config = function()
        require("bufjump").setup({
            forward_key = false,
            backward_key = false,
            on_success = nil
        })
    end,
    keys={
        {"<C-S-o>", function() require("bufjump"):backward() end, desc = "Bufjump previous"},
        {"<C-S-i>", function() require("bufjump"):forward() end, desc = "Bufjump next"},
    },
}
