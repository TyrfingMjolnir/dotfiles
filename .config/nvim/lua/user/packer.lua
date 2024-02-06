vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
	use 'nvimtools/none-ls.nvim'
	use 'wbthomason/packer.nvim'
	use {
		'nvim-telescope/telescope.nvim', tag = '0.1.5',
		requires = { { 'nvim-lua/plenary.nvim' } }
	}
	use ( {
		'rose-pine/neovim',
		as = 'rose-pine',
		config = function()
			vim.cmd('colorscheme rose-pine')
		end
	})
	use 'tpope/vim-dadbod'
	use 'vimwiki/vimwiki'
	use 'tpope/vim-commentary'
	use 'christoomey/vim-tmux-navigator'
	use 'will133/vim-dirdiff'
	use 'tpope/vim-fugitive'
	use 'tpope/vim-surround'
	use 'kristijanhusak/vim-dadbod-ui'
	use {
		'goolord/alpha-nvim',
		requires = { 'nvim-tree/nvim-web-devicons' },
		config = function ()
			require'alpha'.setup(require'alpha.themes.startify'.config)
		end
	}
	use (
		'nvim-treesitter/nvim-treesitter',
		{ run = ":TSUpdate" }
	)
	use ( 'nvim-treesitter/playground' )
	use ( 'mbbill/undotree' )
	use {
		'nvim-lualine/lualine.nvim',
		requires = { 'nvim-tree/nvim-web-devicons', opt = true }
	}
	use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
	use 'apple/sourcekit-lsp'
	use({
		"kdheepak/lazygit.nvim",
-- optional for floating window border decoration
	requires = {
		"nvim-lua/plenary.nvim",
	}
})
end)

