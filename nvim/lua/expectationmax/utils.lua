local os = require("os")
local M = {}
M.path_sep = vim.loop.os_uname().sysname == "Windows" and "\\" or "/"
function M.path_join(...)
    return table.concat(vim.tbl_flatten {...}, M.path_sep)
end

function M.on_attach(client, bufnr)
    local wk = require("which-key")
    local tb = require("telescope.builtin")
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    local opts = { noremap=true, silent=true }
    wk.register({
        ["<leader>l"] = {
            name = "+lsp",
            a = {vim.lsp.buf.code_action, "Action"},

            c = {
                name = "+calls",
                i = {tb.lsp_incomming_calls, "Incomming"},
                o = {tb.lsp_incomming_calls, "Outgoing"},
            },

            d = {
                name= "+diagnosics",
                d = {function() tb.diagnostics({bufnr=bufnr}) end, "Document"},
                w = {tb.diagnostics, "Workspace"},
                h = {vim.diagnostic.open_float, "Hovering float"}
            },

            f = {vim.lsp.buf.format, "Format"},

            g = {
                name = "+goto",
                d = {tb.lsp_definitions, "Goto definition(s)"},
                D = {vim.lsp.buf.declaration, "Goto declaration"},
                i = {tb.lsp_implementations, "Goto implementation(s)"},
                t = {tb.lsp_type_definitions, "Goto type definition(s)"},
            },

            h = {vim.lsp.buf.hover, "Hover"},

            re = {tb.lsp_references, "References"},
            rn = {vim.lsp.buf.rename, "Rename"},

            s = {
                name = "+symbols",
                d = {tb.lsp_document_symbols, "Document"},
                w = {tb.lsp_workspace_symbols, "Workspace"},
            },

            w = {
                name = "+workspace folders",
                a = {vim.lsp.buf.add_workspace_folder, "Add workspace folder"},
                r = {vim.lsp.buf.remove_workspace_folder, "Remove workspace folder"},
                l = {function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, "List workspace folders"},
            },
        },
    }, {buffer = bufnr, mode="n"})

    buf_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
    buf_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
    -- buf_set_keymap("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
    buf_set_keymap("i", "<C-s>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
    -- buf_set_keymap("i", "<C-s>", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
    buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
    buf_set_keymap("n", "<leader>e", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
    buf_set_keymap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
    buf_set_keymap("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
    buf_set_keymap("n", "<leader>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)
    buf_set_keymap("n", "<leader>f", "<cmd>lua vim.lsp.buf.format()<CR>", opts)
    vim.opt_local.tagfunc = "v:lua.vim.lsp.tagfunc"

    if client.server_capabilities.documentHighlight ~= nil then
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

    
    vim.api.nvim_set_hl(0, "LspReference", {
        bg = "#665c54",
        ctermbg = 59,
    })
    vim.api.nvim_set_hl(0, "LspReferenceText", {
        link = "LspReference",
    })
    vim.api.nvim_set_hl(0, "LspReferenceRead", {
        link = "LspReference",
    })
    vim.api.nvim_set_hl(0, "LspReferenceWrite", {
        link = "LspReference",
    })
    --[[
    vim.api.nvim_create_autocmd("CursorHold", {
        buffer = bufnr,
        callback = function ()
            vim.diagnostic.open_float({ focusable = false })
        end
    })
    --]]
end

return M
