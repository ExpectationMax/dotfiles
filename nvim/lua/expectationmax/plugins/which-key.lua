function config()
    local wk = require("which-key")
    wk.register(
        {
            p = { name = "[P]roject" },
            z = { name = "[Z]ettelkasten" },
            g = { name = "[G]it" },
            o = { name = "[O]llama" },
            d = { name = "[D]ebugger" },
            s = { name = "[S]earch"}
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
