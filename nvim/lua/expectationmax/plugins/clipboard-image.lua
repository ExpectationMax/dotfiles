function config(_)
    local os = require("os")
    local nb_dir_path = os.getenv("ZK_NOTEBOOK_DIR")
    local utils = require("expectationmax.utils")
    local img_dir = utils.path_join({ nb_dir_path, "attachments" })

    require("clipboard-image").setup({
        default = {
            img_dir = img_dir,
            img_dir_txt = "attachments",
            img_name = function() return "Pasted image " .. os.date('%Y%m%d%H%M%S') end,
            affix = "markdown"
        }
    })
end
return {
    "dfendr/clipboard-image.nvim",
    config=config,
    cmd = { "PasteImg" }
}
