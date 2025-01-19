local os = require("os")
local utils = require("expectationmax.utils")
local on_attach = utils.on_attach
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
    ['<C-x>'] = cmp.mapping(
      cmp.mapping.complete({
        config = {
          sources = cmp.config.sources({
            { name = 'cmp_ai' },
          }),
        },
      }),
      { 'i' }
    ),
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

local function project_root_or_cur_dir(path)
    return lspconfig.util.root_pattern("pyproject.toml", "Pipfile", ".git")(path) or vim.fn.getcwd()
end

lsp_defaults = lspconfig.util.default_config

lsp_defaults.capabilities = vim.tbl_deep_extend(
  'force',
  lsp_defaults.capabilities,
  require('cmp_nvim_lsp').default_capabilities()
)

-- lspconfig.rust_analyzer.setup({
--     on_attach = on_attach,
-- })

lspconfig.pylsp.setup({
    cmd = {utils.path_join(os.getenv("HOME"), ".vim/run_with_venv.sh"), utils.path_join(os.getenv("HOME"), ".neovim_venv/bin/python"), "-m", "pylsp"},
    on_attach = on_attach,
    settings = {
        pylsp = {
            configurationSources = {"flake8"},
            plugins ={
                rope_completion = {enabled = false},
                jedi_completion = {
                    enabled = true,
                    include_params = true,
                    eager = true,
                    fuzzy = true,
                    include_class_objects = true,
                    cache_for = {
                        "pandas",
                        "numpy",
                        "polars",
                        "torch",
                        "matplotlib"
                    }
                },
                preload = {enabled = true},
                pyflakes = {enabled = false},
                pycodestyle = {enabled = false},
                pydocstyle = {
                  enabled = false,
                  convention = "pep257",
                  addIgnore = {"D102", "D104", "D107", "D2", "D3", "D4"},
                },
                pylint = {enabled = false},
                black = {enabled = false},
                flake8 = {
                    enabled = false,
                    executable = "~/.neovim_venv/bin/flake8",
                    ignore = {"D102", "D104", "D2", "D3", "D4"},
                    maxLineLength = 101
                },
                ruff = {
                    enabled = true,
                    formatEnabled = true
                },
                mypy = {
                    enabled = true,
                    live_mode = true,
                }
            }
        }
    },
})


lspconfig.clangd.setup({})

local my_arduino_fqbn = {
    ["/Users/hornm/Projects/google_home_timer/google_home_timer_display"] = "rp2040:rp2040:rpipicow",
}

local DEFAULT_FQBN = "arduino:avr:uno"

lspconfig.arduino_language_server.setup({
    on_new_config = function (config, root_dir)
        local fqbn = my_arduino_fqbn[root_dir]
        if not fqbn then
            vim.notify(("Could not find which FQBN to use in %q. Defaulting to %q."):format(root_dir, DEFAULT_FQBN))
            fqbn = DEFAULT_FQBN
        end
        config.cmd = {
            "arduino-language-server",
            "-clangd", "/opt/homebrew/Cellar/llvm/17.0.6/bin/clangd",
            -- "-clangd", "/usr/bin/clangd",
            "-cli", "/opt/homebrew/bin/arduino-cli",
            "-cli-config", utils.path_join(os.getenv("HOME"), "Library/Arduino15/arduino-cli.yaml"),
            -- "-log",
            "-fqbn",
            fqbn
        }
    end,
    root_dir = project_root_or_cur_dir,
    on_attach = on_attach
})

lspconfig.rust_analyzer.setup({
    on_attach = function(client, bufnr)
        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
        on_attach(client, bufnr)
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
