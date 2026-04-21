local map = vim.keymap.set

-- Only non-Telescope mappings for now
map("n", "<leader>u", "<cmd>UndotreeToggle<cr>", { desc = "UndoTree" })

-- Add any other global keymaps here (e.g. for DadBod if you use it)
-- map("n", "<leader>db", "<cmd>DBUI<cr>", { desc = "DadBod UI" })

-- Normal mode: Alt+J down, Alt+K up
map("n", "<A-j>", ":m .+1<CR>==", { noremap = true, silent = true })
map("n", "<A-k>", ":m .-2<CR>==", { noremap = true, silent = true })

-- Insert mode: Alt+J down, Alt+K up (returns to insert mode)
map("i", "<A-j>", ":m .+1<CR>==gi", { noremap = true, silent = true })
map("i", "<A-k>", ":m .-2<CR>==gi", { noremap = true, silent = true })

-- Visual mode: Shift+J down, Shift+K up
map("v", "J", ":m '>+1<CR>gv=gv", { noremap = true, silent = true })
map("v", "K", ":m '<-2<CR>gv=gv", { noremap = true, silent = true })


map('n', ';', ':')
map('n', ':', ';')
map('n', '<Esc>', '<cmd>nohlsearch<CR>')
map('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- LSP keymaps (apply to all servers including SourceKit)
map("n", "gd", vim.lsp.buf.definition, { desc = "Go to Definition" })
map("n", "gr", vim.lsp.buf.references, { desc = "Go to References" })
map("n", "K", vim.lsp.buf.hover, { desc = "Hover Documentation" })
map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename" })
map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
map("n", "<leader>cf", function() vim.lsp.buf.format({ async = true }) end, { desc = "Format" })
