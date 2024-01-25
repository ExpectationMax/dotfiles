return {
    "rcarriga/nvim-dap-ui",
    dependencies = {{"mfussenegger/nvim-dap", main="dap"}},
    main = "dapui",
    config = function()
        local dap, dapui =require("dap"),require("dapui")
        dap.listeners.after.event_initialized["dapui_config"]=function()
          dapui.open()
        end
        dap.listeners.before.event_terminated["dapui_config"]=function()
          dapui.close()
        end
        dap.listeners.before.event_exited["dapui_config"]=function()
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
    }
}

