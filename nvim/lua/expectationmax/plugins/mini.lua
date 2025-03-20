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

local surround_mappings = {
    add = "gsa", -- Add surrounding in Normal and Visual modes
    delete = "gsd", -- Delete surrounding
    find = "gsf", -- Find surrounding (to the right)
    find_left = "gsF", -- Find surrounding (to the left)
    highlight = "gsh", -- Highlight surrounding
    replace = "gsr", -- Replace surrounding
    update_n_lines = "gsn", -- Update `n_lines`,
}

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
        opts = {
            mappings = surround_mappings,
            respect_selection_type = true,
        },
        keys = function(_, keys)
            -- Populate the keys based on the user's options
            local mappings = surround_mappings
            local mappings = {
                { mappings.add, desc = "Add Surrounding", mode = { "n", "v" } },
                { mappings.delete, desc = "Delete Surrounding" },
                { mappings.find, desc = "Find Right Surrounding" },
                { mappings.find_left, desc = "Find Left Surrounding" },
                { mappings.highlight, desc = "Highlight Surrounding" },
                { mappings.replace, desc = "Replace Surrounding" },
                { mappings.update_n_lines, desc = "Update `MiniSurround.config.n_lines`" },
            }
            mappings = vim.tbl_filter(function(m)
                return m[1] and #m[1] > 0
            end, mappings)
            return vim.list_extend(mappings, keys)
        end,
        init = function()
            -- Disable s to avoid accidentally using builtin version
            vim.keymap.set({ 'n', 'x' }, 's', '<Nop>')
        end,
    },

    {
        "echasnovski/mini.pairs",
        version = false,
        config = true
    }

}
