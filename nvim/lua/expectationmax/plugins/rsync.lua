return {
    "OscarCreator/rsync.nvim",
    build = "make",
    dependencies = {"nvim-lua/plenary.nvim"},
    event = { "BufWritePre" },
    opts = {
        -- triggers sync when git repo was changed
        fugitive_sync = true,
        -- triggers `RsyncUp` when you save a file.
        sync_on_save = true
    },
    keys = { {"<leader>pu", vim.cmd.RsyncUp, desc="Project upload via rsync"} },
    cmd = {"RsyncUp", "RsyncUpFile", "RsyncDown"}
}
