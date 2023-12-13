require'nvim-treesitter.configs'.setup {
	-- A list of parser names, or "all" (the five listed parsers should always be installed)
	ensure_installed = { "graphql", "html", "json", "json5", "make", "markdown", "markdown_inline", "regex", "r", "ssh_config", "xml", "yaml", "dot", "thrift", "objc", "dtd", "dot", 
	"http", "latex", "doxygen", "gitattributes", "gitignore", "bash", "python", "lua", "php", "solidity", "vim", "sql", "vimdoc", "rust", "c", "cpp", "javascript" },

	-- Install parsers synchronously (only applied to `ensure_installed`)
	sync_install = false,

	-- Automatically install missing parsers when entering buffer  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
	auto_install = true,

	highlight = {
		enable = true,

		additional_vim_regex_highlighting = false,
	},
}
