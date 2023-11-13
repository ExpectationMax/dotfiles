return {
    "mickael-menu/zk-nvim",
    config = function()
        require("zk").setup({
            picker = "telescope",
        })
        require("telescope").load_extension("zk")  -- Activate zk extension
    end,
    keys = {
        {"<leader>zn", function() require("zk").new({ title = vim.fn.input("Title: "), dir = "zettel" }) end, desc = "Create a new zettel note"},
        {"<leader>zm", function() require("zk").new({ title = vim.fn.input("Title: "), dir = "MOC" }) end, desc = "Create a new MOC note"},
        {"<leader>zs", "<cmd>ZkNotes<cr>", desc = "Search notes"}
    },
    cmd = {"ZkNew", "ZkIndex", "ZkNewFromTitleSelection", "ZkNewFromContentSelection", "ZkNotes", "ZkLinks", "ZkInsertLink", "ZkInsertLinkAtSelection", "ZkTags"}
}
