# My neovim config

It is my own Neovim configuration. It is created (at least, copy-pasted) by
me for me.

The config is only tested on and intended for the latest stable release,
because some plugins break backward compatibility.

Licensed under [MIT License](./LICENSE)

## Features

All the features are located in `lua/feature` directory.

### Automatic language server configuration loading

Language server configurations are not hardcoded into the `lspconfig` setup
code. To add a new language server configuration, create a file in
`lua/language-servers` directory, place the setup code here and it will be
loaded and configured automatically.

### Colorscheme saver

Change current colorscheme by typing `:Colorscheme <scheme name>`, get current
scheme name by typing `:Colorscheme`. Colorscheme will be saved and restored on
next start up.

### Add extra paths to Python LSP

Pylsp does not see the modules installed system-wide or per user, and thus
does not provide autocompletion, hints, documentation, etc. This feature
provides single command `:PythonExtraPaths`, which gets all the installation
paths from `pip` and stores them into cache file. Then this file will be read
on each LSP startup, adding extra paths to `jedi`.
