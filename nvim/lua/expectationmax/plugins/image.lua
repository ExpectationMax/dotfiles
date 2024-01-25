return {
    "3rd/image.nvim",
    -- event = "VeryLazy",
    lazy=true,
    config=function()
        require("image").setup()
    end,
    ft = { "markdown" }
}
