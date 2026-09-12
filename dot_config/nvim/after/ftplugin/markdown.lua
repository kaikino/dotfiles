vim.opt_local.conceallevel = 0
vim.opt_local.textwidth = 0
vim.opt_local.wrap = true
-- <leader>mt toggles the checkbox on the current line.
vim.keymap.set("n", "<leader>mt", function()
  local line = vim.api.nvim_get_current_line()
  if line:match("%[ %]") then
    vim.api.nvim_set_current_line((line:gsub("%[ %]", "[x]", 1)))
  elseif line:match("%[[xX]%]") then
    vim.api.nvim_set_current_line((line:gsub("%[[xX]%]", "[ ]", 1)))
  end
end, { buffer = true, silent = true, desc = "Toggle checkbox" })
