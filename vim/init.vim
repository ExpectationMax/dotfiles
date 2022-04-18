set nocompatible              " be iMproved, required

" If plug is not installed bootstrap it
if empty(glob("~/.vim/plug.vim"))
    execute '!curl -fLo ~/.vim/plug.vim https://raw.github.com/junegunn/vim-plug/master/plug.vim'
endif
source ~/.vim/plug.vim
source ~/.vim/plugins.vim

filetype plugin indent on
syntax on

" set encoding, no swapfile
set encoding=utf8
set noswapfile

" Appearance
set number
set noshowmode          " Dont show the mode, we have lightline for that
set showtabline=1       " Show tabline only if more than one tab is open

set guifont=Fira\ Code\ Retina:h14

set termguicolors
" let &t_8f = "\e[38;2;%lu;%lu;%lum"
" let &t_8b = "\e[48;2;%lu;%lu;%lum"
" let &t_ZH="\e[3m"
" let &t_ZR="\e[23m"
set background=dark
let g:gruvbox_italic=1
let g:gruvbox_contrast_dark = 'hard'
let g:gruvbox_contrast_light = 'hard'
colorscheme gruvbox8

" Highlighting applied to floating window
highlight LspDiagnosticsErrorFloating guifg=#fb4934 gui=NONE ctermfg=NONE ctermbg=NONE cterm=NONE
highlight LspDiagnosticsWarningFloating guifg=#fabd2f gui=NONE ctermfg=NONE ctermbg=NONE cterm=NONE
highlight LspDiagnosticsInfoFloating guifg=#83a598 gui=NONE ctermfg=NONE ctermbg=NONE cterm=NONE
" Highlighting applied to code
highlight LspDiagnosticsUnderlineError guifg=NONE guibg=NONE guisp=#fb4934 gui=undercurl ctermfg=NONE ctermbg=NONE cterm=undercurl
highlight LspDiagnosticsUnderlineWarning guifg=NONE guibg=NONE guisp=#fabd2f gui=undercurl ctermfg=NONE ctermbg=NONE cterm=undercurl
highlight LspDiagnosticsUnderlineInfo guifg=NONE guibg=NONE guisp=#83a598 gui=undercurl ctermfg=NONE ctermbg=NONE cterm=undercurl

highlight LspReference guifg=NONE guibg=#665c54 guisp=NONE gui=NONE cterm=NONE ctermfg=NONE ctermbg=59
highlight! link LspReferenceText LspReference
highlight! link LspReferenceRead LspReference
highlight! link LspReferenceWrite LspReference

set laststatus=2        " Always show status line
set list                " Show tab and EOL
set listchars=trail:·,tab:▸\  " Use the following symbols
set conceallevel=2

" Folding
set foldmethod=syntax
set foldlevel=20


set updatetime=1000

" Beviour
" One tab equals 4 spaces, an entered tab is automatically converted
set tabstop=8 softtabstop=0 expandtab shiftwidth=4 smarttab
set formatoptions=jn1croql

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
set completeopt=menuone,noselect

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
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 25
let ghregex='\(^\|\s\s\)\zs\.\S\+'
let g:netrw_list_hide='__pycache__'
let g:netrw_list_hide.=',' . ghregex

" Python paths
let g:python3_host_prog = $HOME . "/.neovim_venv/bin/python3"

source ~/.vim/custom_commands.vim

function SetupGit()
    setlocal spell
endfunction

function SetupTex()
    setlocal colorcolumn=120
    setlocal tw=119
    setlocal spell
    setlocal spelllang=en_gb
    setlocal nosmartindent
    setlocal wildignore+=*.acn,*.aux,*.bbl,*.bcf,*.blg,*.fdb_latexmk,*.fls,*.glg,*.glo,*.gls,*.idx,*.ilg,*.ind,*.ist,*.log,*.,run.xml,*.toc
    setlocal tabstop=2 softtabstop=2 shiftwidth=2 autoindent
    " call SetupLsp()
endfunction

" function SetupLsp()
"     nnoremap <silent> <buffer> <leader>ld <cmd>lua vim.lsp.diagnostic.set_loclist()<CR>
"     nnoremap <silent> <buffer> gd    <cmd>lua vim.lsp.buf.definition()<CR>
"     nnoremap <silent> <buffer> K  <cmd>lua vim.lsp.buf.hover()<CR>
"     nnoremap <silent> <buffer> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
"     inoremap <silent> <buffer> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
"     nnoremap <silent> <buffer> <leader>ls    <cmd>lua vim.lsp.buf.document_symbol()<CR>
"     nnoremap <silent> <buffer> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
"     nnoremap <buffer> <leader>lr <cmd>call LspRename()<CR>
"     nnoremap <silent> <buffer> <leader>lf <cmd>call Preserve('lua vim.lsp.buf.formatting_sync(nil, 1000)')<CR>
"     " nmap <buffer> <leader>lf <plug>(lsp-document-format)
"     " vmap <buffer> <C-f> <plug>(lsp-document-format)
"     " nmap <buffer> <leader>lt <plug>(lsp-type-definition)
"     " nmap <buffer> <leader>lx <plug>(lsp-references)
"     " nmap <buffer> <leader>ls <plug>(lsp-document-symbol)
"     autocmd CursorHold  <buffer> lua vim.lsp.buf.document_highlight()
"     autocmd CursorHold  <buffer> lua vim.lsp.diagnostic.show_line_diagnostics({focusable = false})
"     autocmd CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()
"     autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
"     " autocmd BufWritePre <buffer> call Preserve('lua vim.lsp.buf.formatting_sync(nil, 1000)')
"     lua require 'tagfunc_nvim_lsp'
"     setlocal tagfunc=v:lua.tagfunc_nvim_lsp
"     setlocal signcolumn=yes
" endfunction

function SetupMarkdown()
    setlocal colorcolumn=80
    setlocal tw=79
    setlocal spell
    nnoremap <buffer> <silent> <leader>p :call mdip#MarkdownClipboardImage()<CR>
    nnoremap <buffer> <F6> "=strftime("%Y-%m-%d")<CR>P
    inoremap <buffer> <F6> <C-R>=strftime("%Y-%m-%d")<CR>
endfunction

function SetupYaml()
    set filetype=yaml foldmethod=indent
    setlocal ts=2 sts=2 sw=2 expandtab
endfunction

function SetupPython()
    setlocal colorcolumn=101
    setlocal tw=100
    setlocal signcolumn=yes
    setlocal spell
    setlocal tabstop=4 shiftwidth=4 expandtab
    " call SetupLsp()
endfunction

function SetupTerminal()
    setlocal nonumber norelativenumber
    setlocal scrollback=10000
    startinsert
endfunction

autocmd Filetype gitcommit call SetupGit()
autocmd FileType gitcommit set bufhidden=delete  " Delete gitcommit buffer when hidden
let $GIT_EDITOR = 'nvr -cc split --remote-wait'

autocmd Filetype tex call SetupTex()
autocmd Filetype markdown call SetupMarkdown()
autocmd Filetype vimwiki call SetupMarkdown()
autocmd Filetype python call SetupPython()
autocmd BufNewFile,BufReadPost *.{yaml,yml} call SetupYaml()
autocmd! BufNewFile,BufRead Dvcfile,*.dvc,dvc.lock call SetupYaml()
" autocmd Filetype javascript,typescript,solidity call SetupLsp()

if has('nvim')
    " Remove line numbers and go to insert mode when creating a new terminal
    autocmd TermOpen * call SetupTerminal()
    " Go to insert mode as soon as focusing on terminal
    " autocmd FocusGained,BufEnter,BufWinEnter,WinEnter term://* startinsert
    " Removed as it is anoying when opening a term in a tab and switching
    " through tabs
endif

" General keybindings
" Disable regular arrow keys
" noremap <up> <NOP>
" noremap <down> <NOP>
" noremap <left> <NOP>
" noremap <right> <NOP>
" Disable default vim completion. We have NCM2 for that.
inoremap <C-n> <NOP>
" Disable Ex mode
nnoremap Q <Nop>
" Window management
nnoremap <silent> <leader>yw :call WindowSwap#MarkWindowSwap()<CR>
nnoremap <silent> <leader>pw :call WindowSwap#DoWindowSwap()<CR>
" Terminal mode
tnoremap <C-h> <C-\><C-n><C-w>h
tnoremap <C-j> <C-\><C-n><C-w>j
tnoremap <C-k> <C-\><C-n><C-w>k
tnoremap <C-l> <C-\><C-n><C-w>l
tnoremap <C-w>N <C-\><C-n>
tnoremap <C-w>h <C-\><C-n><C-w>h
tnoremap <C-w>j <C-\><C-n><C-w>j
tnoremap <C-w>k <C-\><C-n><C-w>k
tnoremap <C-w>l <C-\><C-n><C-w>l
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
