require 'options'
require 'map'

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
	local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
	if vim.v.shell_error ~= 0 then
		error('Error cloning lazy.nvim:\n' .. out)
	end
end

vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
	{
		'mbbill/undotree',
		lazy = false,
		config = function()
			vim.opt.undofile=true
			vim.keymap.set( "n", "<leader>u", vim.cmd.UndotreeToggle )
			vim.g.undotree_WindowLayout=2
		end
	},
	require 'plugin.telescope',
	require 'plugin.wiki',
	require 'plugin.commentary',
	require 'plugin.surround',
	require 'plugin.dadbod',
	require 'plugin.lspconfig',
	require 'plugin.autocomplete',
	require 'plugin.tokyonight'
})

