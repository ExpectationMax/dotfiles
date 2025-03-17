local os = require("os")
local M = {}
M.path_sep = vim.loop.os_uname().sysname == "Windows" and "\\" or "/"
function M.path_join(...)
    return table.concat(vim.tbl_flatten {...}, M.path_sep)
end

function M.python_project_root(path)
    return lspconfig.util.root_pattern("pyproject.toml", "Pipfile", ".git")(path) or vim.fn.getcwd()
end


function M.on_attach(client, bufnr)
    local wk = require("which-key")
    local tb = require("telescope.builtin")

    local map = function(keys, func, desc, mode)
      mode = mode or 'n'
      vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = 'LSP: ' .. desc })
    end

    local function client_supports_method(client, method, bufnr)
    if vim.fn.has 'nvim-0.11' == 1 then
        return client:supports_method(method, bufnr)
      else
        return client.supports_method(method, { bufnr = bufnr })
      end
    end

    local opts = { noremap=true, silent=true }
    wk.add({
        buffer = bufnr,
        { "<leader>l",  group = "lsp" },
        { "<leader>la", vim.lsp.buf.code_action,  desc = "[A]ction" },

        { "<leader>lc",  group = "calls" },
        { "<leader>lci", tb.lsp_incoming_calls,  desc = "[C]alls [I]ncoming" },
        { "<leader>lco", tb.lsp_outgoing_calls,  desc = "[C]alls [O]utgoing" },

        { "<leader>ld",  group = "diagnosics" },
        { "<leader>ldd", function() tb.diagnostics({bufnr=bufnr}) end,  desc = "[D]iagnositics [D]ocument" },
        { "<leader>ldh", vim.diagnostic.open_float,  desc = "[D]iagnostics [H]overing float" },
        { "<leader>ldq", vim.diagnostic.setloclist,  desc = "[D]iagnositcs to [q]ickfix list" },
        { "<leader>ldw", tb.diagnostics,  desc = "[D]iagnostics [W]orkspace" },

        { "<leader>lf", vim.lsp.buf.format,  desc = "Format" },

        { "<leader>lg",  group = "goto" },
        { "<leader>lgD", vim.lsp.buf.declaration,  desc = "[G]oto [D]eclaration" },
        { "<leader>lgd", tb.lsp_definitions,  desc = "[G]oto [d]efinition(s)" },
        { "<leader>lgi", tb.lsp_implementations,  desc = "[G]oto [i]mplementation(s)" },
        { "<leader>lgr", tb.lsp_references,  desc = "[G]oto [r]eferences" },
        { "<leader>lgt", tb.lsp_type_definitions,  desc = "[G]oto [t]ype definition(s)" },

        { "<leader>lh", vim.lsp.buf.hover,  desc = "[H]Hover" },
        { "<leader>lrn", vim.lsp.buf.rename,  desc = "[R]e[n]ame" },

        { "<leader>ls",  group = "symbols" },
        { "<leader>lsd", tb.lsp_document_symbols, buffer = bufrn, desc = "Document" },
        { "<leader>lsw", tb.lsp_workspace_symbols,  desc = "Workspace" },

        { "<leader>lt",  group = "toggle" },
        {
            "<leader>lth",
            function()
                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = bufnr })
            end,
            desc = "[T]oggle Inlay [H]ints"
        },

        { "<leader>lw",  group = "workspace" },
        { "<leader>lwa", vim.lsp.buf.add_workspace_folder,  desc = "Add workspace folder" },
        { "<leader>lwl", function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end,  desc = "List workspace folders" },
        { "<leader>lwr", vim.lsp.buf.remove_workspace_folder,  desc = "Remove workspace folder" },
    })

    map("gd", tb.lsp_definitions, "[G]oto [D]efinition(s)")
    map("K", vim.lsp.buf.hover, "Hover Help")
    map("<C-s>", vim.lsp.buf.signature_help, "Signature help", "i")
    map("gr", tb.lsp_references, "[G]oto [R]eference(s)")
    map("[d", vim.diagnostic.goto_prev, "Previous diagnostic")
    map("]d", vim.diagnostic.goto_next, "Next diagnostic")

    vim.opt_local.tagfunc = "v:lua.vim.lsp.tagfunc"

    if client.server_capabilities.documentHighlightProvider ~= nil then
        vim.api.nvim_create_autocmd("CursorHold", {
            buffer = bufnr,
            callback = vim.lsp.buf.document_highlight
        })
        vim.api.nvim_create_autocmd("CursorHoldI", {
            buffer = bufnr,
            callback = vim.lsp.buf.document_highlight
        })
        vim.api.nvim_create_autocmd("CursorMoved", {
            buffer = bufnr,
            callback = vim.lsp.buf.clear_references
        })
    end

    vim.api.nvim_create_autocmd("CursorHold", {
        buffer = bufnr,
        callback = function ()
            vim.diagnostic.open_float({ focusable = false })
        end
    })
end

return M
