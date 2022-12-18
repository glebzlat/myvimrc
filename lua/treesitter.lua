-- Treesitter parsers directory
vim.opt.runtimepath:append("~/.config/nvim/ts_parsers")

require'nvim-treesitter.configs'.setup {
	ensure_installed = { "cpp", "c", "python", "bash", "ruby", "lua"},
	sync_install = false,
	auto_install = false,

	parser_install_dir = "~/.config/nvim/ts_parsers",

	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
}

-- code folding 
vim.opt.foldmethod = "expr"
vim.cmd [[ set foldexpr=nvim_treesitter#foldexpr() ]]
vim.opt.foldcolumn = "1"

