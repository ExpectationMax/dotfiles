local os = require("os")
local utils = require("expectationmax.utils")
local cmp = require("cmp")
local luasnip = require("luasnip")
local cmp_select_opts = {behavior = cmp.SelectBehavior.Select}

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
    format = function(entry, item)
      local short_name = {
        nvim_lsp = 'LSP',
        nvim_lua = 'nvim'
      }

      local menu_name = short_name[entry.source.name] or entry.source.name

      item.menu = string.format('[%s]', menu_name)
      return item
    end,
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
    buf_set_keymap("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
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
    buf_set_keymap("n", "<leader>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
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
                  convention = "google",
                  ignore = {"D102"},
                  addIgnore = {"D102", "D107"}
                },
                pylint = {enabled = false},
                mypy_ls = {
                    enabled = false,
                    live_mode = true
                },
                black = {enabled = true},
                flake8 = {
                    enabled = true,
                    executable = "~/.neovim_venv/bin/flake8",
                    ignore = {"D102"},
                    maxLineLength = 101
                }
            }
        }
    },
});

lspconfig.jedi_language_server.setup({
    cmd = {utils.path_join(os.getenv("HOME"), ".vim/run_with_venv.sh"), utils.path_join(os.getenv("HOME"), ".neovim_venv/bin/jedi-language-server")},
    on_attach = on_attach,
});
