return {
    "neovim/nvim-lspconfig",
    dependencies = {
        {"williamboman/mason.nvim", opts = {} },
        "williamboman/mason-lspconfig.nvim",
        { "j-hui/fidget.nvim", opts = {} },
        "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
        local os = require("os")
        local utils = require("expectationmax.utils")

        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

        vim.lsp.config("basedpyright", {
            cmd = {utils.path_join(os.getenv("HOME"), ".neovim_venv/bin/basedpyright-langserver"), "--stdio"},
            capabilities = capabilities,
            on_attach = utils.on_attach,
            root_dir = vim.fs.root(0, {".venv/", ".git/",  "pyproject.toml"}),
            settings = {
                -- python = {
                --     -- pythonPath = utils.path_join(os.getenv("HOME"), ".miniforge3/envs/ajax/bin/python"),
                --     pythonPath = utils.path_join(os.getenv("HOME"), ".miniforge3/envs/ajax/bin/python"),
                -- },
                basedpyright = {
                    disableOrganizeImports = false,
                    analysis = {
                        exclude = { "dist/" },
                        autoSearchPaths = true,
                        autoImportCompletions = true,
                        useLibraryCodeForTypes = true,
                        diagnosticMode = "openFilesOnly",
                        typeCheckingMode = "strict",
                        inlayHints = {
                            variableTypes = true,
                            callArgumentNames = true,
                            functionReturnTypes = true,
                            genericTypes = true,
                        },
                    }
                }
            }
        })
        vim.lsp.enable("basedpyright")

        vim.lsp.config("clangd", {on_attach=utils.on_attach})

        vim.lsp.config('clangd', {on_attach=utils.on_attach})
        vim.lsp.enable('clangd')

        vim.lsp.config("rust_analyzer", {
            root_dir = vim.fs.root(0, { "pyproject.toml", ".venv/", ".git/"}),
            on_attach = function(client, bufnr)
                vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
                utils.on_attach(client, bufnr)
            end,
            settings = {
                    ["rust-analyzer"] = {
                        imports = {
                            granularity = {
                                group = "module",
                            },
                            prefix = "self",
                        },
                        cargo = {
                            buildScripts = {
                                enable = true,
                            },
                        },
                        procMacro = {
                            enable = true
                        },
                    }
                }
        })
        vim.lsp.enable("rust_analyzer")

        vim.lsp.enable("sourcekit")
        vim.lsp.config("sourcekit", {on_attach=utils.on_attach})

        vim.lsp.config("sourcekit", {on_attach=utils.on_attach})

        -- Override rename behavior to show quickfix list with changes.
        local default_rename = vim.lsp.handlers["textDocument/rename"]
        local my_rename_handle = function(err, result, ...)
            -- Run default rename handler and add renamed locations to qf list.
            default_rename(err, result, ...)
            if result.documentChanges then
                local entries = {}
                for _, changes in ipairs(result.documentChanges) do
                    -- As we call the default rename fuctionality before, the files
                    -- should already be opened and have a bufnr.

                    local bufnr = vim.uri_to_bufnr(changes.textDocument.uri)

                    for _, edit in ipairs(changes.edits) do
                        local start_line = edit.range.start.line + 1
                        local end_line = edit.range["end"].line + 1
                        local line = vim.api.nvim_buf_get_lines(bufnr, start_line, end_line, false)[1]

                        table.insert(entries, {
                            bufnr = bufnr,
                            lnum = start_line,
                            end_lnum = end_line,
                            col = edit.range.start.character + 1,
                            end_col = edit.range["end"].character + 1,
                            text = line,
                        })
                    end
                end
                if #entries > 1 then
                    vim.fn.setqflist({}, "r", { title = "[LSP] Rename", items = entries })
                    vim.api.nvim_command("botright cwindow")
                end
            end
        end
        vim.lsp.handlers["textDocument/rename"] = my_rename_handle

        vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
          vim.lsp.handlers.signature_help,
          { focus = false }
        )
    end
}
