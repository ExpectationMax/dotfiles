#!/bin/sh
PIPENV_VIRTUAL_ENV=$(pipenv --venv 2>/dev/null)
if [ -z "${PIPENV_VIRTUAL_ENV}" ]; then
   ~/.neovim_venv/bin/python3 -m pyls "$@" 2> ~/.vim/pyls_errors.log
else
   export VIRTUAL_ENV=$PIPENV_VIRTUAL_ENV
   ~/.neovim_venv/bin/python3 -m pyls "$@" 2> ~/.vim/pyls_errors.log
fi

