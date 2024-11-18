return { 'tpope/vim-dadbod', lazy = false },
  { 'kristijanhusak/vim-dadbod-ui',
  lazy = false,
  config = function()
	  vim.keymap.set( "n", "<leader>db", vim.cmd.DBUI )
  end
},
{ 'kristijanhusak/vim-dadbod-completion', lazy = false }
