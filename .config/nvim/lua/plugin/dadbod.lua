return { 'tpope/vim-dadbod',
	lazy = false,
	dependencies = {
  		'kristijanhusak/vim-dadbod-ui',
		'kristijanhusak/vim-dadbod-completion',
	},
	config = function()
		vim.keymap.set( "n", "<leader>db", vim.cmd.DBUI )
	end
}
