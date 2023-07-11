local os = require("os")
local utils = require("expectationmax.utils")
local cmp = require("cmp")
local luasnip = require("luasnip")
local cmp_select_opts = {behavior = cmp.SelectBehavior.Insert}
local lspkind = require("lspkind")

local luasnip_jump_forward = cmp.mapping(
  function(fallback)
    if luasnip.jumpable(1) then
      luasnip.jump(1)
    else
      fallback()
    end
  end,
  {'i', 's'}
)

local luasnip_jump_backward = cmp.mapping(
  function(fallback)
    if luasnip.jumpable(-1) then
      luasnip.jump(-1)
    else
      fallback()
    end
  end,
  {'i', 's'}
)

cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      luasnip.lsp_expand(args.body) -- For `luasnip` users.
    end,
  },
  mapping = {
    ["<C-p>"] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_prev_item(cmp_select_opts)
      else
        cmp.complete()
      end
    end),
    ["<C-n>"] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_next_item(cmp_select_opts)
      else
        cmp.complete()
      end
    end),
    ["<C-y>"] = cmp.mapping.confirm({select = true}),
    ["<C-e>"] = cmp.mapping.close(),
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-u>"] = cmp.mapping.scroll_docs(4),
    ["<CR>"] = cmp.mapping.confirm({
      select = false,
      behavior = cmp.ConfirmBehavior.Replace,
    }),
    ["<C-f>"] = luasnip_jump_forward,
    ["<C-b>"] = luasnip_jump_backward,
  },
  sources = cmp.config.sources(
    {
      { name = "nvim_lsp" },
      { name = "nvim_lua" },
      { name = "luasnip" },
      { name = "path" },
    },
    {
      { name = "buffer" },
    }
  ),
  window = {
    documentation = {
      max_height = 15,
      max_width = 60,
    }
  },
  formatting = {
    fields = {'abbr', 'menu', 'kind'},
    format = lspkind.cmp_format()
  },
})

local lspconfig = require("lspconfig")

local function on_attach(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    local opts = { noremap=true, silent=true }

    buf_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
    buf_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
    buf_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
    buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
    -- buf_set_keymap("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
    buf_set_keymap("i", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
    buf_set_keymap("n", "<leader>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
    buf_set_keymap("n", "<leader>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
    buf_set_keymap("n", "<leader>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
    buf_set_keymap("n", "<leader>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
    buf_set_keymap("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
    buf_set_keymap("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
    buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
    buf_set_keymap("n", "<leader>e", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
    buf_set_keymap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
    buf_set_keymap("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
    buf_set_keymap("n", "<leader>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)
    buf_set_keymap("n", "<leader>f", "<cmd>lua vim.lsp.buf.format()<CR>", opts)
    vim.opt_local.tagfunc = "v:lua.vim.lsp.tagfunc"
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

local function project_root_or_cur_dir(path)
    return lspconfig.util.root_pattern("pyproject.toml", "Pipfile", ".git")(path) or vim.fn.getcwd()
end

local lsp_defaults = lspconfig.util.default_config

lsp_defaults.capabilities = vim.tbl_deep_extend(
  'force',
  lsp_defaults.capabilities,
  require('cmp_nvim_lsp').default_capabilities()
)

lspconfig.pylsp.setup({
    cmd = {utils.path_join(os.getenv("HOME"), ".vim/run_with_venv.sh"), utils.path_join(os.getenv("HOME"), ".neovim_venv/bin/python"), "-m", "pylsp"},
    on_attach = on_attach,
    settings = {
        pylsp = {
            configurationSources = {"flake8"},
            plugins ={
                rope_completion = {enabled = false},
                jedi_completion = {enabled = false},
                preload = {enabled = false},
                pyflakes = {enabled = false},
                pycodestyle = {enabled = false},
                pydocstyle = {
                  enabled = true,
                  convention = "pep257",
                  addIgnore = {"D102", "D104", "D107", "D2", "D3", "D4"},
                },
                pylint = {enabled = false},
                black = {enabled = true},
                flake8 = {
                    enabled = true,
                    executable = "~/.neovim_venv/bin/flake8",
                    ignore = {"D102", "D104", "D2", "D3", "D4"},
                    maxLineLength = 101
                }
            }
        }
    },
})
lspconfig.jedi_language_server.setup({
    cmd = {utils.path_join(os.getenv("HOME"), ".vim/run_with_venv.sh"), utils.path_join(os.getenv("HOME"), ".neovim_venv/bin/jedi-language-server")},
    on_attach = on_attach,
    on_init = function(client)
        client.server_capabilities.renameProvider = nil
    end
})

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
        vim.fn.setqflist({}, "r", { title = "[LSP] Rename", items = entries })
        vim.api.nvim_command("botright cwindow")
    end
end
vim.lsp.handlers["textDocument/rename"] = my_rename_handle

