call plug#begin('~/.vim/plugged')
Plug 'morhetz/gruvbox'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Useful navigation commands
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-surround'

" Completion suggestions
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
let g:deoplete#enable_at_startup = 1
set shortmess+=c
Plug 'Shougo/denite.nvim', { 'do': ':UpdateRemotePlugins' }
" Show function signatures
Plug 'Shougo/echodoc.vim'
let g:echodoc#enable_at_startup = 1

" Taskwarrior integration
Plug 'blindFS/vim-taskwarrior'
" This does not seem to work... strange...
" Plug 'rafi/vim-denite-task'

" Fuzzy search through files and other stuff
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'

" NERD tree file browser and project management
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'

" Find a replacement for vim project
Plug 'amiorin/vim-project'
Plug 'jeffkreeftmeijer/vim-numbertoggle'

" Nicer handling of splits and buffers
" Close buffer while keeping windows intact: BD
" Swap positions of two splits using <leader>ww to select and paste
Plug 'qpkorr/vim-bufkill'
Plug 'wesQ3/vim-windowswap'

" Added support for .editorconfig files
Plug 'editorconfig/editorconfig-vim'

" Git integration
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" Sensible markdown integration
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'

" Python stuff
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }

Plug 'Vimjas/vim-python-pep8-indent'
" Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}
Plug 'heavenshell/vim-pydocstring'
Plug 'vim-python/python-syntax'
let g:python_highlight_all = 1

Plug 'vim-scripts/vim-auto-save'
let g:auto_save_silent = 1  " do not display the auto-save notification

" Documentation stuff
Plug 'vimwiki/vimwiki'
Plug 'tbabej/taskwiki'

" VOoM outliner
Plug 'vim-voom/VOoM'

" Allow to paste clipboard images into Markdown image link
Plug 'ferrine/md-img-paste.vim'
call plug#end()
