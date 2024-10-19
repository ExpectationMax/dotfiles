return {
    "3rd/image.nvim",
    enabled=false,
    -- event = "VeryLazy",
    lazy=true,
    config=function()
        require("image").setup()
    end,
    ft = { "markdown" }
}
