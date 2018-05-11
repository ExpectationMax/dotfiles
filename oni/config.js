const path = require('path');
const activate = (oni) => {
    //oni.commands.executeCommand('browser.openUrl')
    oni.input.bind("<f8>", "markdown.togglePreview")

    // Get last opened workspace and let NERDTree display it
    last_workspace = oni.configuration.getValue('workspace.defaultWorkspace')
    oni.editors.activeEditor.neovim.command('call project#config#welcome()')
    // oni.editors.activeEditor.neovim.command(`NERDTree ${last_workspace}`)
    // If workspace directory changes (through open directory) notify NERDTree to change too
    oni.workspace.onDirectoryChanged.subscribe(
        function(newDir) {
            //oni.editors.activeEditor.neovim.command('NERDTreeCWD')
            console.log('Dir changed!')
        })
    oni.input.bind('<f1>', 'editor.quickInfo.show')
}

module.exports = {
    activate,
    // "oni.hideMenu": true, // Hide default menu, can be opened with <alt>
    "oni.loadInitVim": path.join(process.env.HOME, ".config/oni/init.vim"), // Load user's init.vim
    "oni.useDefaultConfig": true, // Do not load Oni's init.vim
    "tabs.mode": "tabs", // tabs behave like vim
    "tabs.showIndex": true,
    "autoClosingPairs.enabled": false,
    "sidebar.enabled": false,
    "editor.fontSize": "14px",
    "editor.fontFamily": "Inconsolata Nerd Font Mono",
    "editor.completions.mode": "oni",
    "editor.quickInfo.delay": 200,
    //"editor.fontFamily": "DroidSansMono Nerd Font Mono",
    "ui.colorscheme": "onedark",
    // "editor.quickOpen.filterStrategy": "regex", // A strategy for the fuzzy finder closer to CtrlP
    'commandline.mode': false, // Do not override commandline UI
    'wildmenu.mode': false, // Do not override wildmenu UI

    "language.python.textMateGrammar": path.join(process.env.HOME, ".config/oni/python.json"),
    // "language.python.languageServer.command": "~/.oni/run_with_venv.sh",
    "language.python.languageServer.command": path.join(process.env.HOME, ".config/oni/run_pyls_with_venv.sh"),
    // "language.python.languageServer.arguments": ['-v', "--log-file", "/Users/maexlich/pyls.log"]
    "experimental.browser.enabled": true,
    "experimental.markdownPreview.enabled": true,
}

