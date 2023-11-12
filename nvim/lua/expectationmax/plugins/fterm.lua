function config()
local fterm = require("FTerm")
fterm.setup({
    blend = 5
})
end
return {
    "numToStr/FTerm.nvim",
    config=config,
    keys={
        {"<C-CR>", function() require("FTerm").toggle() end, mode = "n", desc = "Toggle floating term"},
        {"<C-CR>", function() require("FTerm").toggle() end, mode = "t", desc = "Toggle floating term"}
    }
}
