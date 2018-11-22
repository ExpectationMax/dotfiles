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
    // "ui.colorscheme": "onedark",
    // Make Oni more Vim like
    "ui.colorscheme": "n/a",
    "sidebar.enabled": false,
    "learning.enabled": false,
    "commandline.mode": false, // Do not override commandline UI
    "wildmenu.mode": false, // Do not override wildmenu UI
    "oni.useDefaultConfig": false,
    "editor.textMateHighlighting.enabled": false,
    "autoClosingPairs.enabled": false,
    // Load oni specific vim config, which chains regular vim config
    "oni.loadInitVim": path.join("/Users/hornm", ".config/oni/init.vim"), // Load user's init.vim
    // Fonts
    "editor.fontSize": "22px",
    "editor.fontFamily": "Inconsolata Nerd Font Mono",
    // Convinience
    "tabs.height": "2em",
    "tabs.showIndex": true,
    "editor.clipboard.enabled": true,
    "experimental.indentLines.enabled": true,
    // Programming, languag server, completions etc.
    "editor.completions.mode": "oni",
    "editor.quickInfo.delay": 200,
    "language.python.languageServer.command": path.join(
      "/Users/hornm",
      ".config/oni/run_pyls_with_venv.sh"
    ),
    "language.python.languageServer.configuration": {
        "pyls.plugins.pydocstyle.enabled": true
    },
    // "language.python.languageServer.command": "/usr/local/share/dotnet/dotnet",
    // "language.python.languageServer.arguments": ["/Users/hornm/Software/python-language-server/output/bin/Release/Microsoft.Python.LanguageServer.dll"],
    // "language.python.languageServer.configuration": {
    //     "interpreter.InterpreterPath": "/usr/local/bin/python3",
    //     "interpreter.Version": 3.6,
    //     "interpreter.DatabasePath": "/Users/hornm/mpyls-database",
    //     "analysisUpdates": true,
    //     "traceLogging": true, // Max level, let LS decide through settings actual level of logging.
    //     "asyncStartup": true
    // },
    "experimental.browser.enabled": true,
    "experimental.markdownPreview.enabled": false,
}
