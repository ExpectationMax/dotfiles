return {
    "ThePrimeagen/git-worktree.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function() 
        require("git-worktree").setup()
        require("telescope").load_extension("git_worktree")
    end,
    cmd = { "Telescope" },
    keys = {
        {"<leader>gw", function() require('telescope').extensions.git_worktree.create_git_worktree() end, desc = "Create git worktree"},
        {"<leader>gm", function() require('telescope').extensions.git_worktree.git_worktrees() end, desc = "Manage git worktrees" }
    }
}
