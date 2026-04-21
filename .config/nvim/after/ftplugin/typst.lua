vim.bo.makeprg = "typst compile %:p"
local map = vim.keymap.set

-- Run `typst watch` in a vertical split terminal (recommended for live watching)
map("n", "<leader>tw", function()
  -- Escape the current filename safely and open in a vertical terminal split
  local cmd = "typst watch " .. vim.fn.shellescape(vim.fn.expand("%:p"))
  vim.cmd("vsplit | terminal " .. cmd)

  -- Optional: make the terminal window narrower and go back to the editor
  vim.cmd("vertical resize 60")
  vim.cmd("wincmd p")  -- go back to the previous (Typst) window
end, { desc = "Typst watch (in vertical terminal)" })

-- Alternative: Run in background (no terminal visible, just compiles silently)
map("n", "<leader>tW", function()
  local cmd = "typst watch " .. vim.fn.shellescape(vim.fn.expand("%:p")) .. " &"
  vim.fn.jobstart(cmd, { detach = true })
  vim.notify("Typst watch started in background", vim.log.levels.INFO)
end, { desc = "Typst watch (background)" })
