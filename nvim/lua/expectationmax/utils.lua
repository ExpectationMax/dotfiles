local os = require("os")
local M = {}
M.path_sep = vim.loop.os_uname().sysname == "Windows" and "\\" or "/"
function M.path_join(...)
    return table.concat(vim.tbl_flatten {...}, M.path_sep)
end

return M
