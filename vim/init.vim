set nocompatible              " be iMproved, required
filetype off                  " deactivate for now, reactivate later

" If plug is not installed bootstrap it
if empty(glob("~/.vim/plug.vim"))
    execute '!curl -fLo ~/.vim/plug.vim https://raw.github.com/junegunn/vim-plug/master/plug.vim'
endif
source ~/.vim/plug.vim
source ~/.vim/plugins.vim

" set encoding, no
set encoding=utf8
set noswapfile

" Appearance
set number
set noshowmode          " Dont show the mode, we have airline for that

set termguicolors
let &t_8f = "\e[38;2;%lu;%lu;%lum"
let &t_8b = "\e[48;2;%lu;%lu;%lum"
let &t_ZH="\e[3m"
let &t_ZR="\e[23m"

set background=dark
let g:gruvbox_italic=1
colorscheme gruvbox
set laststatus=2        " Always show status line
set list                " Show tab and EOL
set listchars=trail:·,tab:▸\  " Use the following symbols
set conceallevel=2

" Beviour
" One tab equals 4 spaces, an entered tab is automatically converted
set tabstop=8 softtabstop=0 expandtab shiftwidth=4 smarttab
set formatoptions+=qrn1

" split are to the right and bottom
set splitbelow
set splitright

" search while typing
set incsearch
" Case if pattern contains case
set ignorecase
set smartcase

" Completion
set shortmess+=c " Hide messages
" Don't use preview, echodoc is sufficient for most cases
set completeopt=menuone,noinsert,noselect

" Customized spell-file
set spellfile=~/.vim/spell/en.utf-8.add
" Regenerate spl files if the change data of add file is newer than is.
" This is required as vim uses the spl file for spellchecking, but it is not
" compatible across platforms
for d in glob('~/.vim/spell/*.add', 1, 1)
    if filereadable(d) && (!filereadable(d . '.spl') || getftime(d) > getftime(d . '.spl'))
        silent exec 'mkspell! ' . fnameescape(d)
    endif
endfor

" Customize netrw
let g:netrw_liststyle = 3     " view dir listing as tree
let g:netrw_banner = 0        " remove banner
" let g:netrw_browse_split = 2  " open files in vertical splits
" let g:netrw_altv = 1          " open splits to the right
let g:netrw_winsize = 15      " make split area 25% of the window size

" Python paths
let g:python3_host_prog = "/usr/local/bin/python3"

source ~/.vim/custom_commands.vim

function SetupGit()
    :setlocal spell
endfunction

function SetupTex()
    :setlocal colorcolumn=80
    :setlocal tw=79
    :setlocal signcolumn=yes
    :setlocal spell
endfunction

function SetupLsp()
    :nmap <buffer> <leader>ld <plug>(lsp-document-diagnostics)
    :nmap <buffer> gd <plug>(lsp-definition)
    :nmap <buffer> <leader>lr <plug>(lsp-rename)
    :nmap <buffer> <leader>lf <plug>(lsp-document-format)
    :vmap <buffer> <C-f> <plug>(lsp-document-format)
    :nmap <buffer> <leader>lt <plug>(lsp-type-definition)
    :nmap <buffer> <leader>lx <plug>(lsp-references)
    :nmap <buffer> <leader>lh <plug>(lsp-hover)
    :imap <buffer> <C-h> <plug>(lsp-hover)
    :nmap <buffer> <leader>ls <plug>(lsp-document-symbol)
endfunction

function SetupMarkdown()
    :setlocal colorcolumn=80
    :setlocal tw=79
    :setlocal spell
    :nnoremap <buffer> <silent> <leader>p :call mdip#MarkdownClipboardImage()<CR>
    :nnoremap <buffer> <F6> "=strftime("%Y-%m-%d")<CR>P
    :inoremap <buffer> <F6> <C-R>=strftime("%Y-%m-%d")<CR>
endfunction

function SetupPython()
    :setlocal colorcolumn=80
    :setlocal tw=79
    :setlocal signcolumn=yes
    :call SetupLsp()
endfunction

function SetupTerminal()
    :setlocal nonumber norelativenumber
    :startinsert
endfunction

autocmd Filetype gitcommit call SetupGit()
autocmd FileType gitcommit set bufhidden=delete  " Delete gitcommit buffer when hidden
let $GIT_EDITOR = 'nvr -cc split --remote-wait'

autocmd Filetype tex call SetupTex()
autocmd Filetype markdown call SetupMarkdown()
autocmd Filetype python call SetupPython()
if has('nvim')
    " Remove line numbers and go to insert mode when creating a new terminal
    autocmd TermOpen * call SetupTerminal()
    " Go to insert mode as soon as focusing on terminal
    autocmd FocusGained,BufEnter,BufWinEnter,WinEnter term://* startinsert
endif

" autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif

" General keybindings
" Disable regular arrow keys
noremap <up> <NOP>
noremap <down> <NOP>
noremap <left> <NOP>
noremap <right> <NOP>
" Window management
nnoremap <silent> <leader>yw :call WindowSwap#MarkWindowSwap()<CR>
nnoremap <silent> <leader>pw :call WindowSwap#DoWindowSwap()<CR>
" Terminal mode
tnoremap <C-h> <C-\><C-n><C-w>h
tnoremap <C-j> <C-\><C-n><C-w>j
tnoremap <C-k> <C-\><C-n><C-w>k
tnoremap <C-l> <C-\><C-n><C-w>l
tnoremap <C-w>h <C-\><C-n><C-w>h
tnoremap <C-w>j <C-\><C-n><C-w>j
tnoremap <C-w>k <C-\><C-n><C-w>k
tnoremap <C-w>l <C-\><C-n><C-w>l
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
tnoremap <C-x> <C-\><C-n>

syntax on
filetype plugin indent on
