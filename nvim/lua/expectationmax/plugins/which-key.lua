function config()
    local wk = require("which-key")
    wk.register(
        {
            p = { name = "Project" },
            z = { name = "Zettelkasten" }
        },
        { prefix = "<leader>" }
    )
end
return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
  end,
  config=config
}