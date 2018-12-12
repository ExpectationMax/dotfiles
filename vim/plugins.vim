call plug#begin('~/.vim/plugged')
Plug 'morhetz/gruvbox'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Useful navigation commands
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-surround'

" Fuzzy search through files and other stuff
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'

" NERD tree file browser and project management
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'

" Find a replacement for vim project
Plug 'amiorin/vim-project'
Plug 'jeffkreeftmeijer/vim-numbertoggle'

" Commands to ease use of terminal
Plug 'kassio/neoterm'

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
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
let g:deoplete#enable_at_startup = 1

Plug 'Vimjas/vim-python-pep8-indent'
Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}
Plug 'heavenshell/vim-pydocstring'
Plug 'vim-scripts/vim-auto-save'
Plug 'bfredl/nvim-ipy'
" nteract integration with markdown
Plug 'vyzyv/vimpyter'

" Requirement for veebugger
Plug 'Shougo/vimproc.vim', {'do' : 'make'}
Plug 'idanarye/vim-vebugger'

" Documentation stuff
Plug 'vimwiki/vimwiki'

" VOoM outliner
Plug 'vim-voom/VOoM'

" Plug   'KeitaNakamura/tex-conceal.vim' ", {'for': 'tex'}

" Allow to paste clipboard images into Markdown image link
Plug 'ferrine/md-img-paste.vim'
call plug#end()
