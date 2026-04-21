-- after/ftplugin/sql.lua
local map = vim.keymap.set

-- makeprg uses psql with the current file (works great with Unix socket)
vim.bo.makeprg = "psql -f %:p"

-- Optional: trigger LSP formatting on save for SQL files
vim.api.nvim_create_autocmd("BufWritePre", {
  buffer = 0,
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})

-- Keymaps
map("n", "<leader>sr", "<cmd>DB < %<cr>", { desc = "Run current SQL file" })
map("n", "<leader>se", "<cmd>DBExecRange<cr>", { desc = "Execute selected SQL" })
map("x", "<leader>se", "<cmd>DBExecRange<cr>", { desc = "Execute selected SQL" })

-- Optional: quick reconnect using the global vim.g.db (Unix socket version)
map("n", "<leader>dc", function()
  vim.cmd("DB " .. vim.g.db)
  vim.notify("Connected to PostgreSQL (Unix socket, current user)", vim.log.levels.INFO)
end, { desc = "DadBod connect (current user)" })
