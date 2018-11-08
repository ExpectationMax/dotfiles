 const path = require("path")
const activate = (oni) => {
  //oni.commands.executeCommand('browser.openUrl')
  oni.input.bind("<f8>", "markdown.togglePreview")
  // Get last opened workspace and let NERDTree display it
  // last_workspace = oni.configuration.getValue("workspace.defaultWorkspace")
  oni.editors.activeEditor.neovim.command("call project#config#welcome()")
};

module.exports = {
    activate,
    // change configuration values here:
    "ui.colorscheme": "onedark",
    "oni.useDefaultConfig": false,
    "oni.loadInitVim": path.join("/Users/hornm", ".config/oni/init.vim"), // Load user's init.vim
    "tabs.showIndex": true,
    "autoClosingPairs.enabled": false,
    "sidebar.enabled": false,
    "editor.fontSize": "22px",
    "editor.fontFamily": "Inconsolata Nerd Font Mono",
    "editor.completions.mode": "oni",
    "editor.quickInfo.delay": 200,
    "commandline.mode": false, // Do not override commandline UI
    "wildmenu.mode": false, // Do not override wildmenu UI
    "experimental.indentLines.enabled": true,
    "language.python.languageServer.command": path.join(
      "/Users/hornm",
      ".config/oni/run_pyls_with_venv.sh"
    ),
    "experimental.browser.enabled": true,
    "experimental.markdownPreview.enabled": false,
}
