call plug#begin('~/.vim/plugged')
" General

function! LspStatus() abort
  if luaeval('#vim.lsp.buf_get_clients() > 0')
    return luaeval("require('lsp-status').status()")
  endif

  return ''
endfunction

" Appearance
let g:gruvbox_filetype_hi_groups = 1
let g:gruvbox_plugin_hi_groups = 1
Plug 'lifepillar/vim-gruvbox8'
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
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Editorconfig
Plug 'editorconfig/editorconfig-vim'

let g:voom_python_versions = [3]
let g:voom_ft_modes = {'markdown': 'markdown', 'wiki': 'markdown', 'tex': 'latex', 'python': 'python'}
Plug 'vim-voom/VOoM'

" Project and time management

" Markdown
Plug 'godlygeek/tabular'
" Allow to paste clipboard images into Markdown image link
let g:mdip_imgdir = 'img'
Plug 'ferrine/md-img-paste.vim'

" vimwiki
let g:vimwiki_list = [
    \ {
      \ 'path': '~/PhDwiki/',
      \ 'syntax': 'markdown',
      \ 'ext': '.md',
      \ 'index': 'index',
      \ 'auto_toc': 1,
      \ 'auto_diary_index': 1,
      \ 'nested_syntaxes': {'python': 'python', 'bash': 'bash'}
  \ },
    \ {
      \ 'path': '~/Internship/',
      \ 'syntax': 'markdown',
      \ 'ext': '.md',
      \ 'index': 'index',
      \ 'auto_toc': 1,
      \ 'auto_diary_index': 1,
      \ 'nested_syntaxes': {'python': 'python', 'bash': 'bash'}
      \ }]
let g:vimwiki_global_ext = 0
let g:vimwiki_markdown_link_ext = 1

Plug 'vimwiki/vimwiki'
command! Diary VimwikiDiaryIndex
augroup vimwikigroup
    autocmd!
    " automatically update links on read diary
    autocmd BufRead,BufNewFile diary.md VimwikiDiaryGenerateLinks
augroup end

" Template for diary entries
au BufNewFile ~/Internship/diary/*.md
      \ call append(0,[
      \ "# " . split(expand('%:r'),'/')[-1], ""])
au BufNewFile ~/PhDwiki/diary/*.md
      \ call append(0,[
      \ "# " . split(expand('%:r'),'/')[-1], ""])

" pandoc: Citation and advanced markdown support
let g:pandoc#filetypes#handled = ["pandoc", "markdown"]
let g:pandoc#biblio#bibs = [$HOME."/Internship/references.bib"]
let g:pandoc#biblio#use_bibtool = 1
let g:pandoc#completion#bib#mode = 'citeproc'
Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax'

" Activate syntax plugin
augroup pandoc_syntax
  autocmd! FileType vimwiki set syntax=markdown.pandoc
augroup END

" Zettelkasten
let g:zettel_format = "/zettelkasten/%y%m%d-%H%M"
let g:zettel_date_format = "%d.%m.%y"
let g:zettel_options = [{"template" :  $HOME."/Internship/templates/zettel_vim.md"}]
Plug 'michal-h21/vim-zettel'


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
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

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
Plug 'vim-python/python-syntax'
Plug 'Vimjas/vim-python-pep8-indent'
let g:pydocstring_doq_path = $HOME."/.neovim_venv/bin/doq"
let g:pydocstring_formatter = "google"
Plug 'heavenshell/vim-pydocstring'
Plug 'bfredl/nvim-ipy'
call plug#end()

" Solidity
Plug 'tomlion/vim-solidity'


lua << EOF
--- Some generally useful functions
require('os')
local path_sep = vim.loop.os_uname().sysname == "Windows" and "\\" or "/"
local function path_join(...)
    return table.concat(vim.tbl_flatten {...}, path_sep)
end

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
        ['<C-y>'] = cmp.mapping.confirm({
            select = true,
            behavior = cmp.ConfirmBehavior.Replace,
        }),
        ['<Tab>'] = function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end,
        ['<S-Tab>'] = function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end,
    },
    sources = cmp.config.sources(
    {
      { name = 'nvim_lsp' },
      { name = 'luasnip' }
    },
    {
      { name = 'buffer' },
    })
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
lsp_status.config({
    indicator_errors = "✗",
    indicator_warnings = "‼",
    indicator_info = "i",
    indicator_hint = "h"
})
lsp_status.register_progress()

local function on_attach(client, bufnr)
    lsp_status.on_attach(client)
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

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
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
    cmd = {path_join(os.getenv("HOME"), ".vim/run_pyls_with_venv.sh")},
    on_attach = on_attach,
    settings = {
        pylsp = {
            configurationSources = {"flake8"},
            plugins ={
                pyflakes = {enabled = false},
                pycodestyle = {enabled = false},
                pydocstyle = {enabled = false},
                pylint = {enabled = false},
                mypy_ls = {
                    enabled = false,
                    live_mode = true
                },
                black = {enabled = true},
                flake8 = {
                    enabled = true,
                    executable = "~/.neovim_venv/bin/flake8"
                }
            }
        }
    },
    capabilities = capabilities
});

--- nvim_lsp.tsserver.setup({
---    on_attach = on_attach
--- })
--- nvim_lsp.solang.setup({
---     capabilities = vim.tbl_extend('keep', configs.solang.capabilities or {}, lsp_status.capabilities)
---     })
--- 
--- nvim_lsp.texlab.setup({
---     on_attach = on_attach,
---     settings = {
---         texlab = {
---           build = {
---             executable = "latexmk",
---             args = {"-interaction=nonstopmode", "-synctex=1", "-pv", "%f"},
---             onSave = false,
---             forwardSearchAfter = true,
---           },
---           forwardSearch = {
---             executable = "/Applications/Skim.app/Contents/SharedSupport/displayline",
---             args = {"-g", "%l", "%p", "%f"}
---           }
---         }
---       },
---     capabilities = vim.tbl_extend('keep', configs.texlab.capabilities or {}, lsp_status.capabilities)
--- })
--- 
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
