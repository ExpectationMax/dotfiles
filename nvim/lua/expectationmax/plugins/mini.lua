return {
    {
        "echasnovski/mini.ai",
        version = false,
        config = function(_, opt)
            local gen_spec = require("mini.ai").gen_spec
            require("mini.ai").setup({
                n_lines = 500,
                custom_textobjects = {
                    m = gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
                    o = gen_spec.treesitter({
                        a = { "@block.outer", "@conditional.outer", "@loop.outer" },
                        i = { "@block.inner", "@conditional.inner", "@loop.inner" },
                    }),
                    -- s = gen_spec.treesitter({ a = "@local.scope", i = "@local.scope" }),
                    c = gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" })
                }
            })
        end
    },
    {
        "echasnovski/mini.surround",
        version = false,
        config = true
    }
}
