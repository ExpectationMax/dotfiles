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

function! GetPoetryVenv()
    let l:poetry_config = findfile('pyproject.toml', getcwd().';')
    let l:root_path = fnamemodify(l:poetry_config, ':p:h')
    if !empty(l:poetry_config)
        let l:virtualenv_path = system('cd '.l:root_path.' && poetry env list --full-path')
        return l:virtualenv_path
    endif
endfunction

function! GetPipenvVenv()
    let l:pipenv_config = findfile('Pipfile', getcwd().';')
    let l:root_path = fnamemodify(l:pipenv_config, ':p:h')
    if !empty(l:pipenv_config)
        let l:virtualenv_path = system('cd '.l:root_path.' && pipenv --venv 2>/dev/null')
        return l:virtualenv_path
    endif
    return ''
endfunction

function! GetPythonVenv()
    let l:venv_path = GetPoetryVenv()
    if empty(l:venv_path)
        let l:venv_path = GetPipenvVenv()
    endif
    if empty(l:venv_path)
        return v:null
    else
        return l:venv_path
    endif
endfunction

command! -nargs=0 RunQtPipenv call StartConsolePipenv('jupyter qtconsole')
command! -nargs=0 RunPipenvKernel terminal /bin/bash -i -c 'pipenv run python -m ipykernel'
command! -nargs=0 RunPipenvKernel terminal /bin/bash -i -c 'poetry run python -m ipykernel'
command! -nargs=0 ConnectToPipenvKernel call ConnectToPipenvKernel()
command! -nargs=0 RunQtConsole call jobstart("jupyter qtconsole --existing")
command! -nargs=0 ConnectConsole terminal /bin/bash -i -c 'jupyter console --existing'
command! -nargs=0 AddFilepathToSyspath call AddFilepathToSyspath()
