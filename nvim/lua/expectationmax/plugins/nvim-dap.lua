local os = require("os")
local io = require("io")
local utils = require("expectationmax.utils")

return {
    "rcarriga/nvim-dap-ui",
    dependencies = {
        {"mfussenegger/nvim-dap", main="dap"},
        {
            "mfussenegger/nvim-dap-python",
            main = "dap-python",
            config = function(plugin)
                local dap_python = require("dap-python")
                dap_python.setup(utils.path_join(os.getenv("HOME"), ".neovim_venv/bin/python"))
                dap_python.resolve_python = function()
                    handle = io.popen([[poetry env info --executable 2>/dev/null]])
                    python_path = handle:read("*a"):match("[^\n ]*")
                    print(python_path)
                    return python_path
                end
            end
        }
    },
    main = "dapui",
    config = function(_, opts)
        local dap, dapui =require("dap"),require("dapui")
        dapui.setup(opts)
        dap.listeners.before.attach.dapui_config = function()
            dapui.open()
        end
        dap.listeners.before.launch.dapui_config = function()
            dapui.open()
        end
        dap.listeners.before.event_terminated.dapui_config = function()
            dapui.close()
        end
        dap.listeners.before.event_exited.dapui_config = function()
            dapui.close()
        end
        vim.fn.sign_define("DapBreakpoint",{ text = "", texthl = "", linehl = "", numhl = "", color = "red"})
        vim.fn.sign_define("DapStopped",{ text = "", texthl = "", linehl = "", numhl = "", color = "green"})
    end,
    keys = {
        {"<leader>dc", function() require("dap").continue() end, desc="Continue"},
        {"<leader>dn", function() require("dap").step_over() end, desc="Step over (next)"},
        {"<leader>di", function() require("dap").step_into() end, desc="Step into"},
        {"<leader>do", function() require("dap").step_out() end, desc="Step out"},
        {"<leader>db", function() require("dap").toggle_breakpoint() end, desc="Toggle breakpoint"},
        {"<leader>du", function() require("dapui").toggle() end, desc="Toggle UI"}
    }
}

