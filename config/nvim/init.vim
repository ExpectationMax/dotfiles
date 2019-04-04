" Just load the vim config
" source ~/.vim/init.vim
set nocompatible              " be iMproved, required

" Colorscheme and highlighting
set background=dark
syntax on

" set encoding and font
set encoding=utf8

" Show absolute linenumbers in insert mode, relative ones in normal mode
set number relativenumber
set noswapfile
set smartcase

" Dont show the mode
set noshowmode

" Replace tailing whitespaces and tabs
set list
set listchars=trail:·,tab:▸\ 
" One tab equals 4 spaces, an entered tab is automatically converted
set tabstop=8 softtabstop=0 expandtab shiftwidth=4 smarttab
set formatoptions+=qrn1

" Use visual indentation on wrapped lines (especially practival for markdown)
set breakindent
set showbreak=\ >

" split are to the right and bottom
" seems more intuitive to me
set splitbelow
set splitright

set shortmess+=c
" setup python paths
let g:python3_host_prog = "/usr/local/bin/python3"
" Setup python docstring templates
let g:pydocstring_templates_dir = "~/.vim/pydocstring_template"

" If plug is not installed bootstrap it
if empty(glob("~/.vim/plug.vim"))
    execute '!curl -fLo ~/.vim/plug.vim https://raw.github.com/junegunn/vim-plug/master/plug.vim'
endif
source ~/.vim/plug.vim

call plug#begin('~/.vim/plugged')
Plug 'morhetz/gruvbox'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Useful navigation commands
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-surround'

Plug 'jeffkreeftmeijer/vim-numbertoggle'

" Nicer handling of splits and buffers
" Close buffer while keeping windows intact: BD
" Swap positions of two splits using <leader>ww to select and paste
Plug 'qpkorr/vim-bufkill'
Plug 'wesQ3/vim-windowswap'

Plug 'Vimjas/vim-python-pep8-indent'
" Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}
Plug 'vim-python/python-syntax'
let g:python_highlight_all = 1

Plug 'vim-scripts/vim-auto-save'
let g:auto_save_silent = 1  " do not display the auto-save notification

au User lsp_setup call lsp#register_server({
        \ 'name': 'pyls',
        \ 'cmd': {server_info->['/Users/hornm/.vim/run_pyls_with_venv.sh']},
        \ 'whitelist': ['python'],
        \ 'workspace_config': {
        \   'pyls': {
        \      'plugins': {
        \         'pyflakes': {'enabled': v:true},
        \         'pydocstyle': {'enabled': v:true}
        \      }
        \   }
        \ }
        \ })
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'

Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
" Show function signatures
Plug 'Shougo/echodoc.vim'
let g:echodoc#enable_at_startup = 1

call plug#end()
set laststatus=2
let g:gruvbox_italic=1
colorscheme gruvbox
