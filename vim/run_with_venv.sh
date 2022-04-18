#!/bin/bash
COMMAND=$1
shift
if [ -d  ".venv" ]; then
    DETECTED_VIRTUAL_ENV=$PWD/.venv
elif [ -d  "venv" ]; then
    DETECTED_VIRTUAL_ENV=$PWD/venv
else
    DETECTED_VIRTUAL_ENV=$(PIPENV_IGNORE_VIRTUALENVS=1 pipenv --venv 2>/dev/null)
    # If we dont find a pipenv environemnt try poetry
    if [ -z "${DETECTED_VIRTUAL_ENV}" ]; then
        DETECTED_VIRTUAL_ENV=$(poetry env info --path 2>/dev/null)
        retVal=$?
        if [ $retVal -ne 0 ]; then
            echo "No virtual environment detected."
            unset DETECTED_VIRTUAL_ENV
        fi
    fi
fi

echo $DETECTED_VIRTUAL_ENV

if [ -z "${DETECTED_VIRTUAL_ENV}" ]; then
   $COMMAND "$@" 2> ~/.vim/pyls_errors.log
else
   export VIRTUAL_ENV=$DETECTED_VIRTUAL_ENV
   $COMMAND "$@" 2> ~/.vim/pyls_errors.log
fi
