call plug#begin('~/.vim/plugged')
" General

function! LspStatus() abort
  if luaeval('#vim.lsp.buf_get_clients() > 0')
    return luaeval("require('lsp-status').status()")
  endif

  return ''
endfunction

" Appearance
Plug 'ellisonleao/gruvbox.nvim'
" Configure lightline
let g:lightline = {
  \ 'colorscheme': 'jellybeans',
  \ 'active': {
  \   'left': [ [ 'mode', 'paste' ],
  \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ],
  \   'right': [ [ 'lineinfo' ],
  \            [ 'lsp_status', 'fileformat', 'fileencoding', 'filetype' ] ]
  \ },
  \ 'component_function': {
  \   'gitbranch': 'fugitive#Head',
  \   'lsp_status': 'LspStatus'
  \ },
  \ }


" Configure tabline
let g:lightline.tabline = {'left': [ ['tabs'] ]}
let g:lightline.tab = {
    \ 'active': [ 'tabnum', 'filename', 'modified' ],
    \ 'inactive': [ 'tabnum', 'filename', 'modified' ] }
Plug 'itchyny/lightline.vim'

Plug 'knsh14/vim-github-link'

" Saving, navigation and text objects
" Plug 'vim-scripts/vim-auto-save'
" let g:auto_save = 1
" let g:auto_save_in_insert_mode = 0
" let g:auto_save_no_updatetime = 1
" let g:auto_save_silent = 1
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-surround'

" Window and buffer management
Plug 'qpkorr/vim-bufkill'     " Adds command :BD to delete a buffer while leaving splits intact
let g:windowswap_map_keys = 0 " Prevent default bindings
Plug 'wesQ3/vim-windowswap'   " Allow swapping of windows between splits

" Fuzzy search through files buffers etc
" Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
" Plug 'junegunn/fzf.vim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

" Editorconfig
Plug 'editorconfig/editorconfig-vim'

let g:voom_python_versions = [3]
let g:voom_ft_modes = {'markdown': 'markdown', 'wiki': 'markdown', 'tex': 'latex', 'python': 'python'}
Plug 'vim-voom/VOoM'

" Project and time management

" Markdown
Plug 'godlygeek/tabular'
Plug 'ellisonleao/glow.nvim'

" Allow to paste clipboard images into Markdown image link
Plug 'ekickx/clipboard-image.nvim'

" Zettelkasten
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'mickael-menu/zk-nvim'


" Programming
" Terminal
let g:neoterm_default_mod = 'botright'
Plug 'kassio/neoterm'

" TOML files
Plug 'cespare/vim-toml'

" Git integration
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" Completion
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'jc-doyle/cmp-pandoc-references'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

" Signature help
Plug 'ray-x/lsp_signature.nvim'


" Snippets
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'rafamadriz/friendly-snippets'


" Language server support
" Highlighting matching to gruvbox theme
highlight! link LspReferenceText LspReference
highlight! link LspReferenceRead LspReference
highlight! link LspReferenceWrite LspReference

sign define LspDiagnosticsSignError text=✗ texthl=ALEErrorSign linehl= numhl=
sign define LspDiagnosticsSignWarning text=‼ texthl=ALEWarningSign linehl= numhl=
sign define LspDiagnosticsSignInformation text=i texthl=ALEInfoSign linehl= numhl=
sign define LspDiagnosticsSignHint text=h linehl= numhl=

" Predefined configurations for different language servers
Plug 'neovim/nvim-lspconfig'

" Status bar containing language server information
Plug 'nvim-lua/lsp-status.nvim'

" Python
let g:python_highlight_all = 1
" Plug 'vim-python/python-syntax'
" Plug 'Vimjas/vim-python-pep8-indent'
let g:black_virtualenv = $HOME."/.neovim_venv"
Plug 'EgZvor/vim-black'
Plug 'jeetsukumaran/vim-python-indent-black'
let g:pydocstring_doq_path = $HOME."/.neovim_venv/bin/doq"
let g:pydocstring_formatter = "google"
Plug 'heavenshell/vim-pydocstring'
Plug 'bfredl/nvim-ipy'

" Solidity
Plug 'tomlion/vim-solidity'
call plug#end()



lua << EOF
--- Some generally useful functions
require('os')
local path_sep = vim.loop.os_uname().sysname == "Windows" and "\\" or "/"
local function path_join(...)
    return table.concat(vim.tbl_flatten {...}, path_sep)
end

--- Paste images to markdown
require'clipboard-image'.setup({
    default = {
        img_dir = {os.getenv("HOME"), "Notes", "assets", "img"},
    }
})


--- Completion and snippets
local cmp = require('cmp')
local luasnip = require('luasnip')
require('luasnip.loaders.from_vscode').lazy_load()

cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        luasnip.lsp_expand(args.body) -- For `luasnip` users.
      end,
    },
    mapping = {
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.close(),
        ['<CR>'] = cmp.mapping.confirm({
            select = false,
            behavior = cmp.ConfirmBehavior.Replace,
        }),
        ['<Tab>'] = function(fallback)
          if luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end,
        ['<S-Tab>'] = function(fallback)
          if luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end,
    },
    sources = cmp.config.sources(
    {
      { name = 'nvim_lsp' },
      { name = 'luasnip' },
      { name = 'pandoc_references' }
    },
    {
      { name = 'buffer' },
    }),
    experimental = { ghost_text = true },
})

-- `/` cmdline setup.
-- cmp.setup.cmdline('/', {
--   sources = {
--     { name = 'buffer' }
--   }
-- })
-- `:` cmdline setup.
-- cmp.setup.cmdline(':', {
--   sources = cmp.config.sources({
--     { name = 'path' }
--   }, {
--     { name = 'cmdline' }
--   })
-- })


--- Regiser lsp servers
local lspconfig = require('lspconfig')

local lsp_status = require('lsp-status')
local lsp_signature = require('lsp_signature')
lsp_status.config({
    indicator_errors = "✗",
    indicator_warnings = "‼",
    indicator_info = "i",
    indicator_hint = "h"
})
lsp_status.register_progress()
lsp_signature_cfg = {
    bind = false,
    fix_pos = true,
    hint_enable = true,
    hint_prefix = "",
    floating_window = false,
}

local function on_attach(client, bufnr)
    lsp_status.on_attach(client)
    lsp_signature.on_attach(lsp_signature_cfg)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    local opts = { noremap=true, silent=true }

    buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    buf_set_keymap('i', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    buf_set_keymap('n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    buf_set_keymap('n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
    buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
    buf_set_keymap('n', '<leader>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
    buf_set_keymap('n', '<leader>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end

local function project_root_or_cur_dir(path)
    return lspconfig.util.root_pattern('pyproject.toml', 'Pipfile', '.git')(path) or vim.fn.getcwd()
end

local capabilities = require('cmp_nvim_lsp').default_capabilities()
capabilities = vim.tbl_extend('keep', capabilities, lsp_status.capabilities)
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    'documentation',
    'detail',
    'additionalTextEdits',
  }
}
lspconfig.pylsp.setup({
    cmd = {path_join(os.getenv("HOME"), ".vim/run_with_venv.sh"), path_join(os.getenv("HOME"), ".neovim_venv/bin/python"), "-m", "pylsp"},
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
                  convention = 'google',
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
    capabilities = capabilities
});

lspconfig.jedi_language_server.setup({
    cmd = {path_join(os.getenv("HOME"), ".vim/run_with_venv.sh"), path_join(os.getenv("HOME"), ".neovim_venv/bin/jedi-language-server")},
    on_attach = on_attach,
    capabilities = capabilities,
});

require("zk").setup({
  -- can be "telescope", "fzf" or "select" (`vim.ui.select`)
  -- it's recommended to use "telescope" or "fzf"
  picker = "telescope",

  lsp = {
    -- `config` is passed to `vim.lsp.start_client(config)`
    config = {
      cmd = { "zk", "lsp" },
      name = "zk",
      on_attach = on_attach
      -- etc, see `:h vim.lsp.start_client()`
    },

    -- automatically attach buffers in a zk notebook that match the given filetypes
    auto_attach = {
      enabled = true,
      filetypes = { "markdown" },
    },
  },
})

require("nvim-treesitter.configs").setup({
  highlight = {
    additional_vim_regex_highlighting = { "markdown" }
  },
})

--- nvim_lsp.tsserver.setup({
---    on_attach = on_attach
--- })

lspconfig.solidity_ls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        solidity = {
            defaultCompiler = "localFile",
            compileUsingLocalVersion = "/Users/hornm/Downloads/soljson-latest.js",
            packageDefaultDependenciesContractsDirectory = "contracts",
            packageDefaultDependenciesDirectory = "",
            remappings = {
                "@openzeppelin/=/Users/hornm/.brownie/packages/OpenZeppelin/openzeppelin-contracts@4.4.2"
            },
            enabledAsYouTypeCompilationErrorCheck = true,
            validationDelay = 500
        }
    },
    

})

lspconfig.texlab.setup({
    on_attach = on_attach,
    settings = {
        texlab = {
          build = {
            executable = "latexmk",
            args = {"-interaction=nonstopmode", "-synctex=1", "-pv", "%f"},
            onSave = false,
            forwardSearchAfter = true,
          },
          forwardSearch = {
            executable = "/Applications/Skim.app/Contents/SharedSupport/displayline",
            args = {"-g", "%l", "%p", "%f"}
          }
        }
      },
    capabilities = capabilities
})

--- nvim_lsp.clangd.setup({
---     on_attach = on_attach,
---     capabilities = vim.tbl_extend('keep', configs.clangd.capabilities or {}, lsp_status.capabilities)
--- })

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics,
    {
        virtual_text = false
    }
)
EOF
