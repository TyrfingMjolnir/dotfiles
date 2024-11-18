M = {}
function M.undotreestartmeup()
	local undotree = require('mbbill/undotree')
	local config = function()
		vim.opt.undofile=true
		vim.keymap.set( "n", "<leader>u", vim.cmd.UndotreeToggle )
		vim.g.undotree_WindowLayout=2
	end
end
return M
