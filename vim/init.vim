set nocompatible              " be iMproved, required
filetype off                  " required
filetype plugin on
syntax on

set number relativenumber
set noswapfile
set smartcase

" Enable GUI mouse behavior
" set mouse=a

set list
set listchars=trail:·

" split are to the right and bottom
set splitbelow
set splitright

" setup python paths
let g:python3_host_prog = "/usr/local/bin/python3"

" Run bash as if a login shell (needed for osx)
" let &shell='"/bin/bash" -i'

if empty(glob("~/.vim/plug.vim"))
    execute '!curl -fLo ~/.vim/plug.vim https://raw.github.com/junegunn/vim-plug/master/plug.vim'
endif
source ~/.vim/plug.vim

" Settings for project
" before call project#rc()
let g:project_enable_welcome = 1
" NERDTree integration does not work correctly
" the working dir of NT is not set
let g:project_use_nerdtree = 0

let NERDTreeIgnore = ['\.pyc$', '__pycache__']

" Dont use default mapping of windowswap (<leader>ww) as it interferes with
" vimwiki
let g:windowswap_map_keys = 0 "prevent default bindings
nnoremap <silent> <leader>yw :call WindowSwap#MarkWindowSwap()<CR>
nnoremap <silent> <leader>pw :call WindowSwap#DoWindowSwap()<CR>

" Vimwiki path
let g:vimwiki_list = [{'path': '~/PhDwiki/', 'syntax': 'markdown', 'ext': '.md', 'index': 'Home'}]

" Voom file to mode mapping
let g:voom_ft_modes = {'markdown': 'markdown', 'tex': 'latex', 'vimwiki': 'markdown'}

" Convert tex expressions into unicode
set conceallevel=2
let g:tex_conceal="abdgm"

call plug#begin('~/.vim/plugged')
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
Plug 'vim-scripts/vim-auto-save'
Plug 'bfredl/nvim-ipy'
" nteract integration with markdown
Plug 'vyzyv/vimpyter'

" Documentation stuff
Plug 'vimwiki/vimwiki'

" VOoM outliner
Plug 'vim-voom/VOoM'

" Conceal Latex symbols into unicode
Plug   'KeitaNakamura/tex-conceal.vim', {'for': 'tex'}
call plug#end()

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
function! ShowProjects()
    enew
    call project#config#welcome()
endfunction

command! -nargs=0 Projects call ShowProjects()
command! Proj Projects

" set encoding
set encoding=utf8
set guifont=Inconsolata_Nerd_Font_Mono:h10


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

function! GetKernelFromPipenv()
    return tolower(system('basename $(pipenv --venv)'))
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

function! ToggleVoom()
    if !exists('b:voom_active')
        let b:voom_active=1
        execute('Voom')
    else
        execute('Voomquit')
        unlet b:voom_active
    endif
endfunction


" function! StartNteract()
"     let a:venv = GetKernelFromPipenv()
"     let a:flags = '--kernel ' . a:venv
"     let a:command='nteract' . ' ' . b:original_file . ' ' . a:flags
"     call jobstart(a:command)
" endfunction
" command! -nargs=0 StartNteractPipenv call StartNteractPipenv()

command! -nargs=0 RunQtPipenv call StartConsolePipenv('jupyter qtconsole')
command! -nargs=0 RunPipenvKernel terminal /bin/bash -i -c 'pipenv run python -m ipykernel'
command! -nargs=0 RunQtConsole call jobstart("jupyter qtconsole --existing")
command! -nargs=0 AddFilepathToSyspath call AddFilepathToSyspath()
command! -nargs=0 Vtoggle call ToggleVoom()
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

" nnoremap <silent> K :call OniCommand('editor.quickInfo.show')
" let g:ipy_monitor_subchannel = 0
" let g:ipy_autostart = 0
" let g:ipy_perform_mappings = 0
" source ~/.vim/ipy.vim

" xmap <C-enter> <Plug>(IPython-RunLines)<CR>
" nmap <C-enter> <Plug>(IPython-RunLine)<CR>
" nmap <C-S-enter> <Plug>(IPython-RunCell)<CR>
" function! TextEnableCodeSnip(filetype,start,end,textSnipHl) abort
"   let ft=toupper(a:filetype)
"   let group='textGroup'.ft
"   if exists('b:current_syntax')
"     let s:current_syntax=b:current_syntax
"     " Remove current syntax definition, as some syntax files (e.g. cpp.vim)
"     " do nothing if b:current_syntax is defined.
"     unlet b:current_syntax
"   endif
"   execute 'syntax include @'.group.' syntax/'.a:filetype.'.vim'
"   try
"     execute 'syntax include @'.group.' after/syntax/'.a:filetype.'.vim'
"   catch
"   endtry
"   if exists('s:current_syntax')
"     let b:current_syntax=s:current_syntax
"   else
"     unlet b:current_syntax
"   endif
"   execute 'syntax region textSnip'.ft.'
"   \ matchgroup='.a:textSnipHl.'
"   \ start="'.a:start.'" end="'.a:end.'"
"   \ contains=@'.group
" endfunction

" call TextEnableCodeSnip('tex',   '@begin=tex@',   '@end=tex@', 'SpecialComment')

let s:pydoc_path = 'pipenv run python -m pydoc'
nnoremap <silent> K :<C-u>let save_isk = &iskeyword \|
    \ set iskeyword+=. \|
    \ execute "Pyhelp " . expand("<cword>") \|
    \ let &iskeyword = save_isk<CR>
command! -nargs=1 -bar Pyhelp :call ShowPydoc(<f-args>)
function! ShowPydoc(what)
  let bufname = a:what . ".pydoc"
  " check if the buffer exists already
  if bufexists(bufname)
    let winnr = bufwinnr(bufname)
    if winnr != -1
      " if the buffer is already displayed, switch to that window
      execute winnr "wincmd w"
    else
      " otherwise, open the buffer in a split
      execute "sbuffer" bufname
    endif
  else
    " create a new buffer, set the nofile buftype and don't display it in the
    " buffer list
    execute "split" fnameescape(bufname)
    setlocal buftype=nofile
    setlocal nobuflisted
    " read the output from pydoc
    execute "r !" . s:pydoc_path . " " . shellescape(a:what, 1)
  endif
  " go to the first line of the document
  1
endfunction
