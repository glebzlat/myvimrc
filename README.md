# My neovim config

It is my own Neovim configuration. It is created (at least, copy-pasted) by
me for me.

Tested with `Neovim >= v0.9.5`

Licensed under [MIT License](./LICENSE)

## Features

### Automatic language server configuration loading

Language server configurations are not hardcoded into the `lspconfig` setup
code. To add a new language server configuration, create a file in
`lua/language-servers` directory, place the setup code here and it will be
loaded and configured automatically.

### Colorscheme saver

Change current colorscheme by typing `:Colorscheme <scheme name>`, get current
scheme name by typing `:Colorscheme`. Colorscheme will be saved and restored on
next start up.
