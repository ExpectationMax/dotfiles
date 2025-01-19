return {
    'mrcjkb/rustaceanvim',
    enabled = false,
    version = '^5', -- Recommended
    lazy = false, -- This plugin is already lazy
    init = function()
        -- Get path of codelldb
        local mason_registry = require("mason-registry")
        local codelldb = mason_registry.get_package("codelldb")
        local codelldb_install_path = codelldb:get_install_path()
        local cfg = require("rustaceanvim.config")
        local adapter = cfg.get_codelldb_adapter(codelldb_install_path .. "/codelldb", codelldb_install_path .. "/extension/lldb/lib/liblldb.dylib")
        adapter["lldb.showDisassembly"] = "never"

        local cmp_nvim_lsp = require("cmp_nvim_lsp")
        local capabilities = cmp_nvim_lsp.default_capabilities()
        capabilities.workspace = { didChangeWatchedFiles = { dynamicRegistration = true } }

        vim.g.rustaceanvim = {
            server = {
                -- cmd = "/Users/hornm/.cargo/bin/rust-analyzer",
                capabilities = capabilities,
                on_attach = function(client, bufnr)
                    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
                    local utils = require("expectationmax.utils")
                    utils.on_attach(client, bufnr)
                end
            },
            dap = {
                adapter = adapter,
                configuration = {
                    name = 'Rust debug client',
                    type = "codelldb",
                    request = 'launch',
                    stopOnEntry = false,
                    initCommands = {
                        "breakpoint set --name main -N entry",
                        "breakpoint set --name rust_panic"
                    },
                    exitCommands = {
                        "breakpoint delete entry"
                    }
                }
            }
        }
    end
}
