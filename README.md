# Personal dotfiles

This is a repository of my personal dotfiles.

## What does it do?

This repository is based on dotbot, which executes shell commands and builds links config file to the dotfile repository

The repo automatically sets up a minimal development environment for the macOS operating system. It covers:

 * Installation of brew
 * Installation of neovim (https://github.com/neovim/neovim)
 * Installation of python3, pipenv, python-language-server, jupyter and the neovim python package
 * Installation of pyqt to allow usage of the jupyter qtconsole
 
 * Configuration of Oni (https://github.com/onivim/oni) - a neovim based gui editor
    * Improve usability as python ide
    * Wrapper to include current pipenv into python-langauge-server completions
    * Disable KeyPressandHold
    * Disable Sidebar
 
 * Configuration of neovim
    * Included plugins: fzf, nerdtree, vim-fugitive, nvim-ipy
    * pipenv specific extraction of python docstrings
