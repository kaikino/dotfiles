local map = function(mode, lhs, rhs, desc, opts)
  opts = vim.tbl_extend("force", { silent = true, desc = desc }, opts or {})
  vim.keymap.set(mode, lhs, rhs, opts)
end

-------------------------------------------------------------------- basics --
map("n", "<Esc>", "<cmd>nohlsearch<cr>", "Clear search highlight")
map({ "n", "x" }, "<leader>w", "<cmd>write<cr>", "Write file")
map("n", "<leader>W", "<cmd>wall<cr>", "Write all files")
map("n", "<leader>q", "<cmd>confirm quit<cr>", "Quit window")
map("n", "<leader>Q", "<cmd>confirm qall<cr>", "Quit Neovim")

-- Move by screen line when the line is wrapped, unless a count was given.
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", "Down", { expr = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", "Up", { expr = true })

-- Keep the cursor centred on big jumps and search hops.
map("n", "<C-d>", "<C-d>zz", "Half page down")
map("n", "<C-u>", "<C-u>zz", "Half page up")
map("n", "n", "nzzzv", "Next match")
map("n", "N", "Nzzzv", "Previous match")

-- Don't clobber the yank register with the text you just pasted over.
map("x", "p", [["_dP]], "Paste without yanking")
map({ "n", "x" }, "<leader>d", [["_d]], "Delete without yanking")

map("i", "jk", "<Esc>", "Exit insert mode")
map("n", "<leader>a", "ggVG", "Select whole file")

------------------------------------------------------------------- windows --
map("n", "<C-h>", "<C-w>h", "Window left")
map("n", "<C-j>", "<C-w>j", "Window down")
map("n", "<C-k>", "<C-w>k", "Window up")
map("n", "<C-l>", "<C-w>l", "Window right")
map("n", "<C-Up>", "<cmd>resize +2<cr>", "Taller")
map("n", "<C-Down>", "<cmd>resize -2<cr>", "Shorter")
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", "Narrower")
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", "Wider")
map("n", "<leader>-", "<cmd>split<cr>", "Split below")
map("n", "<leader>|", "<cmd>vsplit<cr>", "Split right")
map("n", "<leader>=", "<C-w>=", "Equalise splits")

------------------------------------------------------------------- buffers --
map("n", "<S-h>", "<cmd>bprevious<cr>", "Previous buffer")
map("n", "<S-l>", "<cmd>bnext<cr>", "Next buffer")
map("n", "<leader>bb", "<cmd>buffer #<cr>", "Last buffer")
map("n", "<leader>bd", "<cmd>bdelete<cr>", "Delete buffer")
map("n", "<leader>bo", function()
  local cur = vim.api.nvim_get_current_buf()
  for _, b in ipairs(vim.api.nvim_list_bufs()) do
    if b ~= cur and vim.bo[b].buflisted and not vim.bo[b].modified then
      vim.api.nvim_buf_delete(b, {})
    end
  end
end, "Delete other buffers")

----------------------------------------------------------------- text edit --
map("x", "<", "<gv", "Outdent and keep selection")
map("x", ">", ">gv", "Indent and keep selection")
map("x", "J", ":m '>+1<cr>gv=gv", "Move selection down")
map("x", "K", ":m '<-2<cr>gv=gv", "Move selection up")
map("n", "<A-j>", "<cmd>m .+1<cr>==", "Move line down")
map("n", "<A-k>", "<cmd>m .-2<cr>==", "Move line up")

-- Undo break points, so a long insert isn't one giant undo step.
map("i", ",", ",<C-g>u")
map("i", ".", ".<C-g>u")
map("i", ";", ";<C-g>u")

--------------------------------------------------------------- diagnostics --
map("n", "<leader>xd", vim.diagnostic.open_float, "Line diagnostics")
map("n", "<leader>xl", "<cmd>lopen<cr>", "Location list")
map("n", "<leader>xq", "<cmd>copen<cr>", "Quickfix list")
map("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, "Previous diagnostic")
map("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, "Next diagnostic")
map("n", "[e", function()
  vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR, float = true })
end, "Previous error")
map("n", "]e", function()
  vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR, float = true })
end, "Next error")

-------------------------------------------------------------------- toggles --
map("n", "<leader>uw", function()
  vim.wo.wrap = not vim.wo.wrap
  vim.notify("wrap " .. (vim.wo.wrap and "on" or "off"))
end, "Toggle wrap")
map("n", "<leader>us", function()
  vim.wo.spell = not vim.wo.spell
  vim.notify("spell " .. (vim.wo.spell and "on" or "off"))
end, "Toggle spell")
map("n", "<leader>un", function()
  vim.wo.number = not vim.wo.number
  vim.wo.relativenumber = vim.wo.number
  vim.notify("line numbers " .. (vim.wo.number and "on" or "off"))
end, "Toggle line numbers")
map("n", "<leader>ud", function()
  local on = not vim.diagnostic.is_enabled()
  vim.diagnostic.enable(on)
  vim.notify("diagnostics " .. (on and "on" or "off"))
end, "Toggle diagnostics")
map("n", "<leader>ut", function()
  vim.g.oxblood_transparent = not (vim.g.oxblood_transparent ~= false)
  vim.cmd.colorscheme("oxblood-navy")
  vim.notify("transparency " .. (vim.g.oxblood_transparent and "on" or "off"))
end, "Toggle transparency")
map("n", "<leader>uh", function()
  local buf = vim.api.nvim_get_current_buf()
  local on = not vim.lsp.inlay_hint.is_enabled({ bufnr = buf })
  vim.lsp.inlay_hint.enable(on, { bufnr = buf })
  vim.notify("inlay hints " .. (on and "on" or "off"))
end, "Toggle inlay hints")

-------------------------------------------------------------------- misc --
map("n", "<leader>ol", "<cmd>Lazy<cr>", "Lazy (plugins)")
map("n", "<leader>om", "<cmd>Mason<cr>", "Mason (LSP installer)")
map("n", "<leader>oc", function() vim.cmd.edit(vim.fn.stdpath("config") .. "/init.lua") end, "Edit config")
map("n", "<leader>oh", "<cmd>checkhealth<cr>", "Check health")

-- A terminal that toggles in place, bottom third of the window.
map("n", "<leader>t", function()
  local existing = vim.g.oxblood_term
  if existing and vim.api.nvim_buf_is_valid(existing) then
    local win = vim.fn.bufwinid(existing)
    if win ~= -1 then
      vim.api.nvim_win_close(win, false)
      return
    end
    vim.cmd("botright " .. math.floor(vim.o.lines / 3) .. "split")
    vim.api.nvim_win_set_buf(0, existing)
  else
    vim.cmd("botright " .. math.floor(vim.o.lines / 3) .. "split | terminal")
    vim.g.oxblood_term = vim.api.nvim_get_current_buf()
  end
  vim.cmd.startinsert()
end, "Toggle terminal")
map("t", "<Esc><Esc>", [[<C-\><C-n>]], "Leave terminal mode")
map("t", "<C-h>", [[<C-\><C-n><C-w>h]], "Window left")
map("t", "<C-j>", [[<C-\><C-n><C-w>j]], "Window down")
map("t", "<C-k>", [[<C-\><C-n><C-w>k]], "Window up")
map("t", "<C-l>", [[<C-\><C-n><C-w>l]], "Window right")
