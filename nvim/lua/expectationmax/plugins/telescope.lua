local function custom_grep_string()
    local path = vim.fn.expand('%:p:h')
    if path == '' then
        path = vim.fn.getcwd()
    end

    local qgrep_db = vim.fs.find('.qgrep_db', {
        path = path,
        upward = true,
        type = 'directory'
    })[1]

    local search = vim.fn.input("Grep > ")
    if search == "" then
        return
    end

    if qgrep_db then
        local config_path = vim.fs.joinpath(qgrep_db, 'config.cfg')
        local pickers = require('telescope.pickers')
        local finders = require('telescope.finders')
        local conf = require('telescope.config').values

        pickers.new({}, {
            prompt_title = 'QGrep Search',
            finder = finders.new_oneshot_job({
                "qgrep", "search", config_path, search
            }, {
                entry_maker = function(entry)
                    if not entry or entry == "" then
                        return nil
                    end
                    
                    -- Parse qgrep format: filename:line:text
                    local filename, lnum, text = entry:match("^([^:]+):(%d+):(.*)$")
                    if not filename then
                        return nil
                    end
                    
                    return {
                        value = entry,
                        ordinal = entry,
                        filename = filename,
                        lnum = tonumber(lnum) or 1,
                        col = 1,
                        text = (text or ""):gsub("^%s+", ""),
                        display = function(entry_table)
                            local utils = require('telescope.utils')
                            local display_filename = utils.transform_path({
                                path_display = { "smart" }
                            }, entry_table.filename)
                            
                            return string.format("%s:%s:%s", 
                                display_filename, 
                                entry_table.lnum, 
                                entry_table.text
                            )
                        end
                    }
                end
            }),
            previewer = conf.grep_previewer({}),
            sorter = conf.generic_sorter({}),
        }):find()
    else
        require("telescope.builtin").grep_string({
            search = search
        })
    end
end

function config(telescope)
    local telescope = require("telescope")
    telescope.setup({
        defaults = {
            winblend = 8,
            path_display = { "smart" },
            mappings = {
                i = {
                    ['<C-g>'] = function(prompt_bufnr)
                        -- Use nvim-window-picker to choose the window by dynamically attaching a function
                        local action_set = require('telescope.actions.set')
                        local action_state = require('telescope.actions.state')

                        local picker = action_state.get_current_picker(prompt_bufnr)
                        picker.get_selection_window = function(picker, entry)
                          local picked_window_id = require('window-picker').pick_window() or vim.api.nvim_get_current_win()
                          -- Unbind after using so next instance of the picker acts normally
                          picker.get_selection_window = nil
                          return picked_window_id
                        end

                        return action_set.edit(prompt_bufnr, 'edit')
                    end,
                }
            }
        },
        extensions = {
            ['ui-select'] = {
              require('telescope.themes').get_dropdown(),
            },
            fzf = {
                fuzzy = true,                    -- false will only do exact matching
                override_generic_sorter = true,  -- override the generic sorter
                override_file_sorter = true,     -- override the file sorter
                case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                                 -- the default case_mode is "smart_case"
            }
        },
    })
    pcall(telescope.load_extension, "ui-select")
    pcall(telescope.load_extension, "fzf_native")
    pcall(telescope.load_extension, "frecency")
end


return {

    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope-fzf-native.nvim",
            "nvim-telescope/telescope-ui-select.nvim",
            {
                "nvim-telescope/telescope-frecency.nvim",
                version = "*"
            }
        },
        config=config,
        lazy=true,
        keys={
            {"<leader>pa", function() require("telescope.builtin").find_files() end, desc = "Project find files"},
            {"<leader>pg", function() require("telescope.builtin").live_grep() end, desc = "Project grep (live)"},
            {"<leader>ps", custom_grep_string, desc = "Project grep (not live)"},
            {"<leader>pf", function() require("telescope.builtin").git_files() end, desc = "Project find git files"},
            {"<leader>sh", function() require("telescope.builtin").help_tags() end, desc = "[S]earch [H]elp"},
            {"<leader>sb", function() require("telescope.builtin").buffers() end, desc = "[S]earch [B]uffers"},
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
