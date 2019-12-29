call plug#begin('~/.vim/plugged')
" General

" Appearance
Plug 'morhetz/gruvbox'
" Configure lightline
let g:lightline = {
  \ 'colorscheme': 'jellybeans',
  \ 'active': {
  \   'left': [ [ 'mode', 'paste' ],
  \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
  \ },
  \ 'component_function': {
  \   'gitbranch': 'fugitive#Head'
  \ },
  \ }

" Configure tabline
let g:lightline.tabline = {'left': [ ['tabs'] ]}
let g:lightline.tab = {
    \ 'active': [ 'tabnum', 'filename', 'modified' ],
    \ 'inactive': [ 'tabnum', 'filename', 'modified' ] }
Plug 'itchyny/lightline.vim'

" Saving, navigation and text objects
Plug 'vim-scripts/vim-auto-save'
let g:auto_save = 1
let g:auto_save_in_insert_mode = 0
let g:auto_save_no_updatetime = 1
let g:auto_save_silent = 1
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-surround'

" Window and buffer management
" Plug 'qpkorr/vim-bufkill'     " Adds command :BD to delete a buffer while leaving splits intact
let g:windowswap_map_keys = 0 " Prevent default bindings
Plug 'wesQ3/vim-windowswap'   " Allow swapping of windows between splits

" Fuzzy search through files buffers etc
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'

" Editorconfig
Plug 'editorconfig/editorconfig-vim'

let g:voom_python_versions = [3]
let g:voom_ft_modes = {'markdown': 'markdown', 'tex': 'latex', 'python': 'python'}
Plug 'vim-voom/VOoM'


" Project and time management

" Markdown
" Disable initial folding when opening markdown document
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_frontmatter = 1
let g:vim_markdown_auto_insert_bullets = 1
let g:vim_markdown_new_list_item_indent = 2
Plug 'plasticboy/vim-markdown'
Plug 'godlygeek/tabular'
" Allow to paste clipboard images into Markdown image link
let g:mdip_imgdir = 'img'
Plug 'ferrine/md-img-paste.vim'

" vimwiki
let g:vimwiki_list = [{'path': '~/PhDwiki/', 'syntax': 'markdown', 'ext': '.md', 'index': 'Home'}]
let g:vimwiki_global_ext = 0
Plug 'vimwiki/vimwiki'
command! Diary VimwikiDiaryIndex
augroup vimwikigroup
    autocmd!
    " automatically update links on read diary
    autocmd BufRead,BufNewFile diary.md VimwikiDiaryGenerateLinks
augroup end

" Taskwarrior integration
Plug 'blindFS/vim-taskwarrior'
Plug 'tbabej/taskwiki'

" Programming
" Terminal
Plug 'kassio/neoterm'

" TOML files
Plug 'cespare/vim-toml'

" Git integration
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" Langauage server integration
Plug 'prabirshrestha/async.vim'
highlight link LspErrorHighlight SpellCap
highlight link LspWarningHighlight SpellBad
highlight link LspInformationHighlight SpellBad
highlight link LspHintHighlight SpellBad
let g:lsp_highlight_references_enabled = 1 " highlight variable under cursor
let g:lsp_diagnostics_echo_cursor = 1      " enable echo under cursor when in normal mode
let g:lsp_signs_enabled = 1                " enable signs
let g:lsp_signs_error = {'text': '✗'}
let g:lsp_signs_warning = {'text': '‼'}
let g:lsp_signs_hint = {'text': 'i'}
let g:lsp_virtual_text_enabled = 0         " Disable as signs are sufficient

Plug 'prabirshrestha/vim-lsp'

" Completion suggestions
let g:asyncomplete_remove_duplicates = 1
let g:asyncomplete_smart_completion = 1
let g:asyncomplete_auto_popup = 1

Plug 'prabirshrestha/asyncomplete.vim'
" Allow entering enter when popup is open
inoremap <buffer> <expr> <CR> pumvisible() ? asyncomplete#close_popup() . "\<CR>" : "\<CR>"
inoremap <buffer> <expr> <C-n> pumvisible() ? "\<C-n>" : asyncomplete#force_refresh()
inoremap <buffer> <expr> <C-y> pumvisible() ? asyncomplete#close_popup() : "\<C-y>"
Plug 'prabirshrestha/asyncomplete-buffer.vim'
au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#buffer#get_source_options({
    \ 'name': 'buffer',
    \ 'whitelist': ['markdown', 'vimwiki', 'vim'],
    \ 'blacklist': ['*'],
    \ 'events': ['TextChanged','InsertLeave','BufWinEnter','BufWritePost'],
    \ 'completor': function('asyncomplete#sources#buffer#completor'),
    \ }))
Plug 'prabirshrestha/asyncomplete-file.vim'
au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#file#get_source_options({
    \ 'name': 'file',
    \ 'whitelist': ['*'],
    \ 'blacklist': [],
    \ 'priority': 10,
    \ 'completor': function('asyncomplete#sources#file#completor')
    \ }))
Plug 'prabirshrestha/asyncomplete-lsp.vim'

let g:vista_icon_indent = ["╰─▸ ", "├─▸ "]
let g:vista_executive_for = {
  \ 'python': 'vim_lsp'
  \ }
let g:vista_fzf_preview = ['right:50%']
let g:vista#renderer#enable_icon = 1
let g:vista#renderer#icons = {
\   "function": "\uf794",
\   "variable": "\uf71b",
\  }

Plug 'liuchengxu/vista.vim'


" Python
let g:python_highlight_all = 1
Plug 'vim-python/python-syntax'
Plug 'Vimjas/vim-python-pep8-indent'
let g:pydocstring_templates_dir = "~/.vim/pydocstring_template"
Plug 'heavenshell/vim-pydocstring'
" TODO: Write a function which looks for Pipfile, requirements.txt etc.
au User lsp_setup call lsp#register_server({
        \ 'name': 'pyls',
        \ 'cmd': {server_info->[$HOME.'/.vim/run_pyls_with_venv.sh']},
        \ 'whitelist': ['python'],
        \ 'workspace_config': {
        \   'pyls': {
        \      'plugins': {
        \         'pyflakes': {'enabled': v:true},
        \         'pydocstyle': {'enabled': v:true},
        \         'pylint': {'enabled': v:false}
        \      }
        \   }
        \ }
        \ })
au User lsp_setup call lsp#register_server({
        \ 'name': 'texlab',
        \ 'cmd': {server_info->[$HOME.'/.local/bin/texlab']},
        \ 'whitelist': ['latex', 'tex', 'bib', 'bibtex'],
        \ })
" au User lsp_setup call lsp#register_server({
"         \ 'name': 'pyls',
"         \ 'cmd': {server_info->[$HOME.'/.vim/run_pyls_with_venv.sh']},
"         \ 'whitelist': ['python'],
"         \ 'workspace_config': {
"         \   'pyls': {
"         \      'plugins': {
"         \         'pyflakes': {'enabled': v:true},
"         \         'pydocstyle': {'enabled': v:true},
"         \         'pylint': {'enabled': v:true}
"         \      }
"         \   }
"         \ }
"         \ })


" Run code directly in ipython kernel
Plug 'bfredl/nvim-ipy'

call plug#end()
