function config()
    local wk = require("which-key")
    wk.register(
        {
            p = { name = "Project" },
            z = { name = "Zettelkasten" },
            g = { name = "git" },
            o = { name = "ollama" },
            d = { name = "Debugger" },
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
