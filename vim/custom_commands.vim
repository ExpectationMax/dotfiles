" Project related commands
function! ShowProjects()
    enew
    call project#config#welcome()
endfunction
command! -nargs=0 Projects call ShowProjects()
command! Proj Projects

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

" -------------- pipenv stuff --------------
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
