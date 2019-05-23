call plug#begin('~/.vim/plugged')
" General

" Appearance
Plug 'morhetz/gruvbox'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#show_splits = 0
let g:airline#extensions#tabline#show_tabs = 1
let g:airline#extensions#tabline#show_tab_nr = 1
let g:airline#extensions#tabline#show_tab_type = 1
let g:airline#extensions#tabline#show_close_button = 0
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

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

" Taskwarrior integration
Plug 'blindFS/vim-taskwarrior'
Plug 'tbabej/taskwiki'

" Programming

" Git integration
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" Langauage server integration
Plug 'prabirshrestha/async.vim'
highlight link LspErrorHighlight SpellCap
highlight link LspWarningHighlight SpellBad
highlight link LspInformationHighlight SpellBad
highlight link LspHintHighlight SpellBad
let g:lsp_signs_enabled = 0         " enable signs
let g:lsp_diagnostics_echo_cursor = 1 " enable echo under cursor when in normal mode
let g:lsp_virtual_text_enabled = 0 " Have active until new sign api is in neovim
let g:lsp_signs_error = {'text': '✗'}
let g:lsp_signs_warning = {'text': '‼'} " icons require GUI
let g:lsp_signs_hint = {'text': 'i'} " icons require GUI
Plug 'prabirshrestha/vim-lsp'

" Completion suggestions
let g:asyncomplete_remove_duplicates = 1
let g:asyncomplete_smart_completion = 1
let g:asyncomplete_auto_popup = 1

Plug 'prabirshrestha/asyncomplete.vim'
" Allow entering enter when popup is open
inoremap <expr> <CR> pumvisible() ? asyncomplete#close_popup() . "\<CR>" : "\<CR>"
inoremap <expr> <C-n> pumvisible() ? "\<C-n>" : asyncomplete#force_refresh()
inoremap <expr> <C-y> pumvisible() ? asyncomplete#close_popup() : "\<C-y>"
" Plug 'prabirshrestha/asyncomplete-buffer.vim'
" au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#buffer#get_source_options({
"     \ 'name': 'buffer',
"     \ 'whitelist': ['*'],
"     \ 'blacklist': ['go'],
"     \ 'completor': function('asyncomplete#sources#buffer#completor'),
"     \ }))
" Plug 'prabirshrestha/asyncomplete-file.vim'
" au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#file#get_source_options({
"     \ 'name': 'file',
"     \ 'whitelist': ['*'],
"     \ 'blacklist': ['python'],
"     \ 'priority': 10,
"     \ 'completor': function('asyncomplete#sources#file#completor')
"     \ }))
Plug 'prabirshrestha/asyncomplete-lsp.vim'

" Show function signatures
let g:echodoc#enable_at_startup = 1
Plug 'Shougo/echodoc.vim'

" Python
let g:python_highlight_all = 1
Plug 'vim-python/python-syntax'
Plug 'Vimjas/vim-python-pep8-indent'
let g:pydocstring_templates_dir = "~/.vim/pydocstring_template"
Plug 'heavenshell/vim-pydocstring'
" TODO: Write a function which looks for Pipfile, requirements.txt etc.
au User lsp_setup call lsp#register_server({
        \ 'name': 'pyls',
        \ 'cmd': {server_info->['/Users/hornm/.vim/run_pyls_with_venv.sh']},
        \ 'whitelist': ['python'],
        \ 'workspace_config': {
        \   'pyls': {
        \      'plugins': {
        \         'pyflakes': {'enabled': v:true},
        \         'pydocstyle': {'enabled': v:true},
        \         'pylint': {'enabled': v:true}
        \      }
        \   }
        \ }
        \ })

" Run code directly in ipython kernel
Plug 'bfredl/nvim-ipy'


call plug#end()
