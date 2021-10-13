#!/bin/bash
DETECTED_VIRTUAL_ENV=$(PIPENV_IGNORE_VIRTUALENVS=1 pipenv --venv 2>/dev/null)
# If we dont find a pipenv environemnt try poetry
if [ -z "${DETECTED_VIRTUAL_ENV}" ]; then
    DETECTED_VIRTUAL_ENV=$(poetry env info --path 2>/dev/null)
fi

echo $DETECTED_VIRTUAL_ENV

if [ -z "${DETECTED_VIRTUAL_ENV}" ]; then
   ~/.neovim_venv/bin/python3 -m pylsp "$@" 2> ~/.vim/pyls_errors.log
else
   export VIRTUAL_ENV=$DETECTED_VIRTUAL_ENV
   ~/.neovim_venv/bin/python3 -m pylsp "$@" 2> ~/.vim/pyls_errors.log
fi
