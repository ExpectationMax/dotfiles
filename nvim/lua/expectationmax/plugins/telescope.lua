function config(telescope)
    local telescope = require("telescope")
    telescope.setup({
        defaults = {
            winblend = 8,
            path_display = { "smart" },
        },
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
    })
    pcall(telescope.load_extension, "ui-select")
    pcall(telescope.load_extension, "fzy_native")
end
return {
    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope-fzy-native.nvim",
            'nvim-telescope/telescope-ui-select.nvim',
        },
        config=config,
        lazy=true,
        keys={
            {"<leader>pf", function() require("telescope.builtin").find_files() end, desc = "Project find files"},
            {"<leader>pg", function() require("telescope.builtin").live_grep() end, desc = "Project grep (live)"},
            {"<leader>ps", function() require("telescope.builtin").grep_string( { search = vim.fn.input("Grep > ") } ) end, desc = "Project grep (not live)"},
            {"<leader>pv", function() require("telescope.builtin").git_files() end, desc = "Project find git files"},
            {"<leader>sh", function() require("telescope.builtin").buffers() end, desc = "[S]earch [H]elp"},
            {'<leader>sk', function() require("telescope.builtin").keymaps() end, desc = '[S]earch [K]eymaps' },
            {'<leader>sf', function() require("telescope.builtin").find_files() end, desc = '[S]earch [F]iles' },
            {'<leader>ss', function() require("telescope.builtin").builtin() end, desc = '[S]earch [S]elect Telescope' },
            {'<leader>sw', function() require("telescope.builtin").grep_string() end, desc = '[S]earch current [W]ord' },
            {'<leader>sg', function() require("telescope.builtin").live_grep() end, desc = '[S]earch by [G]rep' },
            {'<leader>sd', function() require("telescope.builtin").diagnostics() end, desc = '[S]earch [D]iagnostics' },
            {'<leader>sr', function() require("telescope.builtin").resume() end, desc = '[S]earch [R]esume' },
            {'<leader>s.', function() require("telescope.builtin").oldfiles() end, desc = '[S]earch Recent Files ("." for repeat)' },
            {"<leader><leader>", function() require("telescope.builtin").buffers() end, desc = "Search existing buffers"},
            {
                "<leader>/",
                function()
                    -- You can pass additional configuration to Telescope to change the theme, layout, etc.
                    require("telescope.builtin").current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
                      winblend = 10,
                      previewer = false,
                    })
                end,
                desc = '[/] Fuzzily search in current buffer'
            },
            {
                "<leader>s/",
                function()
                    require("telescope.builtin").live_grep {
                      grep_open_files = true,
                      prompt_title = 'Live Grep in Open Files',
                    }
                end,
                desc = '[S]earch [/] in Open Files'
            },
            {
                "<leader>sn",
                function()
                    require("telescope.builtin").find_files { cwd = vim.fn.stdpath 'config' }
                end, 
                desc = '[S]earch [N]eovim files'
            },
            {"<leader>gb", function() require("telescope.builtin").git_branches() end, desc = "[G]it [b]ranches"}
        },
        cmd = { "Telescope" }
    },
}
