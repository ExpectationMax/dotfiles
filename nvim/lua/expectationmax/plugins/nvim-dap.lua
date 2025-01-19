local os = require("os")
local io = require("io")
local utils = require("expectationmax.utils")

return {
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
            local python_configs = require('dap').configurations.python
            table.insert(python_configs, {
                name = "Pytest: Current File",
                type = "python",
                request = "launch",
                module = "pytest",
                args = {
                    "${file}",
                    "-sv",
                    "--log-cli-level=INFO",
                },
                console = "integratedTerminal",
            })
            table.insert(python_configs, {
                name = "Pytest: All tests",
                type = "python",
                request = "launch",
                module = "pytest",
                args = {
                    "-sv",
                    "--log-cli-level=INFO",
                },
                console = "integratedTerminal",
            })
            table.insert(python_configs, {
                name = "Pytest: All tests, additional cli parameters",
                type = "python",
                request = "launch",
                module = "pytest",
                args = function()
                    args = {
                        "-sv",
                        "--log-cli-level=INFO",
                    }
                    args = vim.list_extend(args, vim.split(vim.fn.input('Arguments: '), " "))
                    return args
                end,
                console = "integratedTerminal",
            })
        end,
    },
    {
        "rcarriga/nvim-dap-ui",
        dependencies = {
            {"nvim-neotest/nvim-nio"},
            {
                "mfussenegger/nvim-dap",
                main="dap",
                config = function()
                    local dap = require "dap"
                    if not dap.adapters then dap.adapters = {} end
                    dap.adapters["probe-rs-debug"] = {
                      type = "server",
                      port = "${port}",
                      executable = {
                        command = vim.fn.expand "$HOME/.cargo/bin/probe-rs",
                        args = { "dap-server", "--port", "${port}" },
                      },
                    }

                    -- Connect the probe-rs-debug with rust files. Configuration of the debugger is done via project_folder/.vscode/launch.json
                    -- require("dap.ext.vscode").type_to_filetypes["probe-rs-debug"] = { "rust" }
                    dap.configurations.rust = {
                        {
                            name = "Run pipico",
                            type = "probe-rs-debug",
                            request = "launch",
                            preLaunchTask = "cargo build",
                            chip = "RP2040",
                            flashingConfig = {
                                flashingEnabled = true,
                                haltAfterReset = true,
                            },
                            coreConfigs = {
                                {
                                  programBinary = "target/thumbv6m-none-eabi/debug/ghome_timer_rust",
                                  rttEnabled = true,
                                }
                            },
                            consoleLogLevel = "Console"
                        }
                    }

                    -- Set up of handlers for RTT and probe-rs messages.
                    -- In addition to nvim-dap-ui I write messages to a probe-rs.log in project folder
                    -- If RTT is enabled, probe-rs sends an event after init of a channel. This has to be confirmed or otherwise probe-rs wont sent the rtt data.
                    dap.listeners.before["event_probe-rs-rtt-channel-config"]["plugins.nvim-dap-probe-rs"] = function(session, body)
                      local utils = require "dap.utils"
                      utils.notify(
                        string.format('probe-rs: Opening RTT channel %d with name "%s"!', body.channelNumber, body.channelName)
                      )
                      local file = io.open("probe-rs.log", "a")
                      if file then
                        file:write(
                          string.format(
                            '%s: Opening RTT channel %d with name "%s"!\n',
                            os.date "%Y-%m-%d-T%H:%M:%S",
                            body.channelNumber,
                            body.channelName
                          )
                        )
                      end
                      if file then file:close() end
                      session:request("rttWindowOpened", { body.channelNumber, true })
                    end
                    -- After confirming RTT window is open, we will get rtt-data-events.
                    -- I print them to the dap-repl, which is one way and not separated.
                    -- If you have better ideas, let me know.
                    dap.listeners.before["event_probe-rs-rtt-data"]["plugins.nvim-dap-probe-rs"] = function(_, body)
                      local message =
                        string.format("%s: RTT-Channel %d - Message: %s", os.date "%Y-%m-%d-T%H:%M:%S", body.channelNumber, body.data)
                      local repl = require "dap.repl"
                      repl.append(message)
                      local file = io.open("probe-rs.log", "a")
                      if file then file:write(message) end
                      if file then file:close() end
                    end
                    -- Probe-rs can send messages, which are handled with this listener.
                    dap.listeners.before["event_probe-rs-show-message"]["plugins.nvim-dap-probe-rs"] = function(_, body)
                      local message = string.format("%s: probe-rs message: %s", os.date "%Y-%m-%d-T%H:%M:%S", body.message)
                      local repl = require "dap.repl"
                      repl.append(message)
                      local file = io.open("probe-rs.log", "a")
                      if file then file:write(message) end
                      if file then file:close() end
                    end
                  end,
            },
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
            dap.listeners.after.event_initialized["dap_exception_breakpoint"] = function()
                dap.set_exception_breakpoints({ "userUnhandled" })
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
}

