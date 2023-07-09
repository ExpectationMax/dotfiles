local os = require("os")
local utils = require("expectationmax.utils")

vim.g.python3_host_prog = utils.path_join(os.getenv("HOME"), ".neovim_venv/bin/python3")
