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
      \ 'path': '~/Internship/',
      \ 'syntax': 'markdown',
      \ 'ext': '.md',
      \ 'index': 'index',
      \ 'auto_toc': 1,
      \ 'auto_diary_index': 1,
      \ 'nested_syntaxes': {'python': 'python', 'bash': 'bash'}
      \ },
    \ {
      \ 'path': '~/PhDwiki/',
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
let g:pandoc#biblio#bibs = ["/Users/hornm/Internship/references.bib"]
let g:pandoc#biblio#use_bibtool = 1
let g:pandoc#completion#bib#mode = 'citeproc'
Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax'

" Activate syntax plugin
augroup pandoc_syntax
  autocmd! FileType vimwiki set syntax=markdown.pandoc
augroup END


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
let g:completion_auto_change_source = 1
let g:completion_confirm_key = "\<C-y>"
let g:completion_chain_complete_list = {
    \ 'default': [
        \ {'complete_items': ['lsp', 'snippet']},
    \ ],
    \ 'vimwiki': [{'complete_items': ['pandoc', 'path'], 'triggered_only': ['@', '/']}],
    \ 'pandoc': [{'complete_items': ['pandoc', 'path'], 'triggered_only': ['@', '/']}],
\}
    "\{'complete_items': ['path'], 'triggered_only': ['/']},
Plug 'nvim-lua/completion-nvim'
augroup completion_markdown
    autocmd!
    autocmd filetype markdown,pandoc,vimwiki lua require'completion'.on_attach()
augroup end

" Plug 'ncm2/ncm2'
" Plug 'roxma/nvim-yarp'
" Plug 'ncm2/ncm2-bufword'
" Plug 'ncm2/ncm2-path'
" Plug 'fgrsnau/ncm2-aspell'
" autocmd BufEnter * call ncm2#enable_for_buffer()
" Enter should close popup window and do newline
inoremap <expr> <CR> (pumvisible() ? "\<C-y>\<cr>" : "\<CR>")

" Language server support
" Predefined configurations for different language servers
Plug 'neovim/nvim-lspconfig'
" Status bar containing language server information
Plug 'nvim-lua/lsp-status.nvim'
" Sidebar containing document symbols
" let g:vista_default_executive = 'nvim_lsp'
" let g:vista#renderer#enable_icon = 1
" let g:vista_executive_for = {
"   \ 'vimwiki': 'markdown',
"   \ 'pandoc': 'markdown',
"   \ 'markdown': 'toc',
"   \ }
" let g:vista_fzf_preview = ['right:50%']
" Plug 'liuchengxu/vista.vim'

" Python
let g:python_highlight_all = 1
Plug 'vim-python/python-syntax'
Plug 'Vimjas/vim-python-pep8-indent'
let g:pydocstring_doq_path = $HOME."/.neovim_venv/bin/doq"
let g:pydocstring_formatter = "google"
Plug 'heavenshell/vim-pydocstring'
Plug 'bfredl/nvim-ipy'
call plug#end()

" Language server protocol
highlight! link LspReferenceText LspReference
highlight! link LspReferenceRead LspReference
highlight! link LspReferenceWrite LspReference

sign define LspDiagnosticsSignError text=✗ texthl=ALEErrorSign linehl= numhl=
sign define LspDiagnosticsSignWarning text=‼ texthl=ALEWarningSign linehl= numhl=
sign define LspDiagnosticsSignInformation text=i texthl=ALEInfoSign linehl= numhl=
sign define LspDiagnosticsSignHint text=h linehl= numhl=

lua << EOF
--- Some generally useful functions
require('os')
local path_sep = vim.loop.os_uname().sysname == "Windows" and "\\" or "/"
local function path_join(...)
    return table.concat(vim.tbl_flatten {...}, path_sep)
end

--- Regiser lsp servers
local nvim_lsp = require('lspconfig')
local configs = require('lspconfig/configs')
local completion = require('completion')

completion.addCompletionSource('vimwiki', require('vimwiki').complete_item)
completion.addCompletionSource('pandoc', require('pandoc').complete_item)


local lsp_status = require('lsp-status')
lsp_status.config({
    indicator_errors = "✗",
    indicator_warnings = "‼",
    indicator_info = "i",
    indicator_hint = "h"
})
lsp_status.register_progress()

local function on_attach(client)
    completion.on_attach(client)
    lsp_status.on_attach(client)
end

local function project_root_or_cur_dir(path)
    return nvim_lsp.util.root_pattern('pyproject.toml', 'Pipfile', '.git')(path) or vim.fn.getcwd()
end

nvim_lsp.pylsp.setup({
    cmd = {path_join(os.getenv("HOME"), ".vim/run_pyls_with_venv.sh")},
    root_dir = project_root_or_cur_dir,
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
    capabilities = vim.tbl_extend('keep', configs.pylsp.capabilities or {}, lsp_status.capabilities)
});

nvim_lsp.texlab.setup({
    on_attach = on_attach,
    settings = {
        latex = {
          build = {
            executable = "latexmk",
            args = {"-interaction=nonstopmode", "-synctex=1", "%f"},
            onSave = true
          },
          forwardSearch = {
            executable = "/Applications/Skim.app/Contents/SharedSupport/displayline",
            args = {"%l", "%p", "%f"}
          }
        }
      },
    capabilities = vim.tbl_extend('keep', configs.texlab.capabilities or {}, lsp_status.capabilities)
})

nvim_lsp.clangd.setup({
    on_attach = on_attach,
    capabilities = vim.tbl_extend('keep', configs.clangd.capabilities or {}, lsp_status.capabilities)
})

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics,
    {
        virtual_text = false
    }
)
EOF
