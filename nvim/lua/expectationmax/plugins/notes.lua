-- Some of the below functionality is adapted from
-- https://github.com/luapower/path
function n_commonpath(s1, s2)
    if p1 == '' or p2 == '' then
        return "/"
    end
    local sep = string.byte('/', 1)
    local si = 0 --index where the last common separator was found
    for i = 1, #s1 + 1 do
        local c1 = string.byte(s1, i)
        local c2 = string.byte(s2, i)
        local sep1 = c1 == nil or c1 == sep
        local sep2 = c2 == nil or c2 == sep
        if sep1 and sep2 then
            si = i
        elseif c1 ~= c2 then
            break
        end
    end
    return si
end

local function depth(p)
    local n = 0
    for _ in p:gmatch('()[^/]+') do
        n = n + 1
    end
    return n
end

function rel(s, pwd, sep)
    local n_prefix = n_commonpath(s, pwd)
    if not n_prefix then return nil end
    local sep = "/"
    local endsep = s:match('/*$')
    local pwd_suffix = pwd:sub(n_prefix + 1)
    local n = depth(pwd_suffix)
    local p1 = ('..' .. sep):rep(n - 1) .. (n > 0 and '..' or '')
    local p2 = s:sub(n_prefix + 1)
    local p2 = p2:gsub('^/+', '')
    local p2 = p2:gsub('/+$', '')
    local p2 = p1 == '' and p2 == '' and '.' or p2
    local p3 = p1 .. (p1 ~= '' and p2 ~= '' and sep or '') .. p2 .. endsep
    return p3
end

return {
    -- ZK configuration
    {
        "mickael-menu/zk-nvim",
        config = function()
            local on_attach = require("expectationmax.utils").on_attach
            require("zk").setup({
                picker = "telescope",
                lsp = { config = { on_attach = on_attach } }
            })
            require("telescope").load_extension("zk")  -- Activate zk extension
        end,
        ft = { "markdown" },
        keys = {
            {"<leader>zn", function() require("zk").new({ title = vim.fn.input("Title: "), dir = "zettel" }) end, desc = "Create a new zettel note"},
            {"<leader>zm", function() require("zk").new({ title = vim.fn.input("Title: "), dir = "MOC" }) end, desc = "Create a new MOC note"},
            {"<leader>zs", "<cmd>ZkNotes<cr>", desc = "Search notes"}
        },
        cmd = {"ZkNew", "ZkIndex", "ZkNewFromTitleSelection", "ZkNewFromContentSelection", "ZkNotes", "ZkLinks", "ZkInsertLink", "ZkInsertLinkAtSelection", "ZkTags"}
    },

    -- Pasting image into neovim from clipboard
    {
        "dfendr/clipboard-image.nvim",
        config=function()
            local os = require("os")
            local nb_dir_path = vim.fn.resolve(vim.fn.expand(os.getenv("ZK_NOTEBOOK_DIR")))
            local utils = require("expectationmax.utils")
            local img_dir = utils.path_join({ nb_dir_path, "attachments" })

            function get_path_to_attachments()
                current_file_dir = vim.fn.expand("%:p:h")
                local relpath = rel(img_dir, current_file_dir)
                return relpath
            end

            require("clipboard-image").setup({
                default = {
                    img_dir = img_dir,
                    img_dir_txt = get_path_to_attachments,
                    img_name = function() return "pasted_" .. os.date('%Y%m%d%H%M%S') end,
                    affix = "markdown"
                }
            })
        end,
        cmd = { "PasteImg" }
    },

    -- Rendering of image in neovim
    {
        "3rd/image.nvim",
        dependencies = {
            "leafo/magick"
        },
        lazy = true,
        enabled = true,
        opts = {},
        ft = { "markdown" }
    }
}
