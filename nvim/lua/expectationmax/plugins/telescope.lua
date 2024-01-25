function config(telescope)
    local telescope = require("telescope")
    telescope.setup({
        defaults = {
            winblend = 8,
            path_display = { "smart" },
        }
    })
    telescope.load_extension("fzy_native")
end
return {
    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = { "nvim-lua/plenary.nvim" },
        config=config,
        lazy=true,
        keys={
            {"<leader>pf", function() require("telescope.builtin").find_files() end, desc = "Project find files"},
            {"<leader>pg", function() require("telescope.builtin").live_grep() end, desc = "Project grep (live)"},
            {"<leader>ps", function() require("telescope.builtin").grep_string( { search = vim.fn.input("Grep > ") } ) end, desc = "Project grep (not live)"},
            {"<leader>pv", function() require("telescope.builtin").git_files() end, desc = "Project find git files"}
        },
        cmd = { "Telescope" }
    },
    {"nvim-telescope/telescope-fzy-native.nvim", lazy = true}
}
