set nocompatible              " be iMproved, required

" set encoding and font
set encoding=utf8
set guifont=Inconsolata_Nerd_Font_Mono:h10

" Show absolute linenumbers in insert mode, relative ones in normal mode
set number relativenumber
set noswapfile
set smartcase

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

" Replace tailing whitespaces and tabs
set list
set listchars=trail:·,tab:▸\ 
" One tab equals 4 spaces, an entered tab is automatically converted
set tabstop=8 softtabstop=0 expandtab shiftwidth=4 smarttab

" Use visual indentation on wrapped lines (especially practival for markdown)
set breakindent
set showbreak=\ >


" split are to the right and bottom
" seems more intuitive to me
set splitbelow
set splitright

" setup python paths
let g:python3_host_prog = "/usr/local/bin/python3"
" Setup python docstring templates
let g:pydocstring_templates_dir = "~/.vim/pydocstring_template"


" If plug is not installed bootstrap it
if empty(glob("~/.vim/plug.vim"))
    execute '!curl -fLo ~/.vim/plug.vim https://raw.github.com/junegunn/vim-plug/master/plug.vim'
endif
source ~/.vim/plug.vim

" Settings for project
" Show welcome screen with projects
let g:project_enable_welcome = 1
" NERDTree integration does not work correctly
" the working dir of NT is not set
let g:project_use_nerdtree = 0

" Hide in NERDTree
let NERDTreeIgnore = ['\.pyc$', '__pycache__']


" Use default nvim_ipy keyindings
let g:nvim_ipy_perform_mappings = 1

" Dont use default mapping of windowswap (<leader>ww) as it interferes with
" vimwiki
let g:windowswap_map_keys = 0 "prevent default bindings
nnoremap <silent> <leader>yw :call WindowSwap#MarkWindowSwap()<CR>
nnoremap <silent> <leader>pw :call WindowSwap#DoWindowSwap()<CR>

" Vimwiki path
let g:vimwiki_list = [{'path': '~/PhDwiki/', 'syntax': 'markdown', 'ext': '.md', 'index': 'Home'}]

" Voom file to mode mapping
let g:voom_ft_modes = {'markdown': 'markdown', 'tex': 'latex', 'vimwiki': 'markdown', 'python': 'python'}

" Convert tex expressions into unicode
set conceallevel=2
let g:tex_conceal="abdgms"

call plug#begin('~/.vim/plugged')
" Useful navigation commands
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-surround'

" Fuzzy search through files and other stuff
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'

" NERD tree file browser and project management
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'ryanoasis/vim-devicons'

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
Plug 'Vimjas/vim-python-pep8-indent'
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

Plug   'KeitaNakamura/tex-conceal.vim' ", {'for': 'tex'}

" Allow to paste clipboard images into Markdown image link
Plug 'ferrine/md-img-paste.vim'
call plug#end()

" Project definitions
call project#rc("~/Projects")
" Load computer specific projects
if empty(glob('~/.vim/projects.vim')) == 0
    source ~/.vim/projects.vim
endif

" Common projects
Project '~/.dotfiles',              'dotfiles'
File '~/.dotfiles/oni/config.js',   'oni-config'
File '~/.dotfiles/vim/init.vim',    'vim-config'
File '~/.vim/projects.vim',         'project-definitions'
call project#rc()

" Project related commands
function! ShowProjects()
    enew
    call project#config#welcome()
endfunction
command! -nargs=0 Projects call ShowProjects()
command! Proj Projects

" Autosave
let g:auto_save = 1
let g:auto_save_in_insert_mode = 0
let g:auto_save_no_updatetime = 1

" Tabularize config
if exists(":Tabularize")
    " Python development, align dictionaries and comments PEP8 conform
    nmap <Leader>a: :Tabularize /:\zs<CR>
    vmap <Leader>a: :Tabularize /:\zs<CR>
    nmap <Leader>a# :Tabularize /#/l2l1<CR>
    vmap <Leader>a# :Tabularize /#/l2l1<CR>
    " Markdown
    nmap <Leader>a| :Tabularize /|<CR>
    vmap <Leader>a| :Tabularize /|<CR>

endif

" Functions and commands for usage as ide
function! GetKernelFromPipenv()
    let a:kernel = tolower(system('basename $(pipenv --venv)'))
    " Remove control characters (most importantly newline)
    return substitute(a:kernel, '[[:cntrl:]]', '', 'g')
endfunction

function! StartConsolePipenv(console)
    let a:flags = '--kernel ' . GetKernelFromPipenv()
    let a:command=a:console . ' ' . a:flags
    echo a:command
    call jobstart(a:command)
endfunction

function! AddFilepathToSyspath()
    let a:filepath = expand('%:p:h')
    call IPyRun('import sys; sys.path.append("' . a:filepath . '")')
    echo 'Added ' . a:filepath . ' to pythons sys.path'
endfunction

function! ConnectToPipenvKernel()
    let a:kernel = GetKernelFromPipenv()
    call IPyConnect('--kernel', a:kernel, '--no-window')
endfunction

command! -nargs=0 RunQtPipenv call StartConsolePipenv('jupyter qtconsole')
command! -nargs=0 RunPipenvKernel terminal /bin/bash -i -c 'pipenv run python -m ipykernel'
command! -nargs=0 ConnectToPipenvKernel call ConnectToPipenvKernel()
command! -nargs=0 RunQtConsole call jobstart("jupyter qtconsole --existing")
command! -nargs=0 AddFilepathToSyspath call AddFilepathToSyspath()


" Truely toggle voom and not only hide on the side
function! ToggleVoom()
    if !exists('b:voom_active')
        let b:voom_active=1
        execute('Voom')
    else
        execute('Voomquit')
        unlet b:voom_active
    endif
endfunction

command! -nargs=0 Vtoggle call ToggleVoom()

" Set textwidth of markdown files
au Filetype markdown setlocal textwidth=80

" Setup mapping to directly paste from clipboard to markdown
autocmd FileType markdown nmap <silent> <leader>p :call mdip#MarkdownClipboardImage()<CR>
autocmd FileType vimwiki nmap <silent> <leader>p :call mdip#MarkdownClipboardImage()<CR>
let g:mdip_imgdir = 'img'

" Activate spellchecking for git commits
au Filetype gitcommit setlocal spell

" Conceal math equations using unicode in vimwiki and markdown files
function! ActivateMarkdownMath()
    syntax include syntax/tex.vim
    syntax include after/syntax/tex.vim
    syntax region mkdMath start="\\\@<!\$" end="\$" skip="\\\$" contains=@texMathZoneGroup keepend
    syntax region mkdMath start="\\\@<!\$\$" end="\$\$" skip="\\\$" contains=@texMathZoneGroup keepend
    " syntax match mathBegin "\\\@<!\$" contained conceal
    " syntax match mathEnd "\$" contained conceal
    " syntax match mathBegin "\\\@<!\$\$" contained conceal
    " syntax match matheEnd "\$\$" contained conceal
endfunction

" augroup texMath
"     autocmd!
"     autocmd FileType markdown call ActivateMarkdownMath()
"     autocmd FileType vimwiki call ActivateMarkdownMath()
" augroup END

" Setup terminal mode
let g:neoterm_autoscroll = 1
" Disable line numbers in terminal
augroup TerminalStuff
  " Clear old autocommands
  autocmd!
  autocmd TermOpen * setlocal nonumber norelativenumber
augroup END


" Allow moving in between windows with Alt+hjkl independent of
" terminal mode
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
" Remap C-ESC to get out of terminal mode
tnoremap <Esc> <C-\><C-n>


" Disable regular arrow keys
noremap <up> <NOP>
noremap <down> <NOP>
noremap <left> <NOP>
noremap <right> <NOP>

" autocmd DirChanged * NERDTreeMapCWD
map <C-M-n> :NERDTreeToggle<CR>
map <C-M-v> :Vtoggle<CR>


" Stuff for Markdown diary/labbook
nnoremap <F6> "=strftime("%Y-%m-%d")<CR>P
inoremap <F6> <C-R>=strftime("%Y-%m-%d")<CR>

set laststatus=2
