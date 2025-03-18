-- Integrate with whichkey
function ai_whichkey(opts)
  local objects = {
    { " ", desc = "whitespace" },
    { '"', desc = '" string' },
    { "'", desc = "' string" },
    { "(", desc = "() block" },
    { ")", desc = "() block with ws" },
    { "<", desc = "<> block" },
    { ">", desc = "<> block with ws" },
    { "?", desc = "user prompt" },
    { "U", desc = "use/call without dot" },
    { "[", desc = "[] block" },
    { "]", desc = "[] block with ws" },
    { "_", desc = "underscore" },
    { "`", desc = "` string" },
    { "a", desc = "argument" },
    { "b", desc = ")]} block" },
    { "c", desc = "class" },
    { "f", desc = "function" },
    { "g", desc = "entire file" },
    { "i", desc = "indent" },
    { "o", desc = "block, conditional, loop" },
    { "q", desc = "quote `\"'" },
    { "u", desc = "use/call" },
    { "{", desc = "{} block" },
    { "}", desc = "{} with ws" },
  }

  ---@type wk.Spec[]
  local ret = { mode = { "o", "x" } }
  ---@type table<string, string>
  local mappings = vim.tbl_extend("force", {}, {
    around = "a",
    inside = "i",
    around_next = "an",
    inside_next = "in",
    around_last = "al",
    inside_last = "il",
  }, opts.mappings or {})
  mappings.goto_left = nil
  mappings.goto_right = nil

  for name, prefix in pairs(mappings) do
    name = name:gsub("^around_", ""):gsub("^inside_", "")
    ret[#ret + 1] = { prefix, group = name }
    for _, obj in ipairs(objects) do
      local desc = obj.desc
      if prefix:sub(1, 1) == "i" then
        desc = desc:gsub(" with ws", "")
      end
      ret[#ret + 1] = { prefix .. obj[1], desc = obj.desc }
    end
  end
  require("which-key").add(ret, { notify = false })
end



return {
    {
        "echasnovski/mini.ai",
        dependencies = {
            {
                -- We depend on the specifications of treesitter queries for defining mini.ai textobjects.
                "nvim-treesitter/nvim-treesitter-textobjects",
                dependencies = { "nvim-treesitter/nvim-treesitter" }
            },
            "folke/which-key.nvim",
        },
        version = false,
        opts = function()
            local gen_spec = require("mini.ai").gen_spec
            return {
                n_lines = 500,
                custom_textobjects = {
                    f = gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
                    o = gen_spec.treesitter({
                        a = { "@block.outer", "@conditional.outer", "@loop.outer" },
                        i = { "@block.inner", "@conditional.inner", "@loop.inner" },
                    }),
                    c = gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
                    u = gen_spec.function_call(), -- u for "Usage"
                    U = gen_spec.function_call({ name_pattern = "[%w_]" }), -- without dot in function name
                }
            }
        end,
        config = function(_, opts)
            require("mini.ai").setup(opts)
            vim.schedule(function()
                ai_whichkey(opts)
            end)
        end
    },

    {
        "echasnovski/mini.surround",
        version = false,
        config = true
    }
}
