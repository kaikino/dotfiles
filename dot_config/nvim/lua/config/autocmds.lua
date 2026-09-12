local augroup = function(name)
  return vim.api.nvim_create_augroup("oxblood_" .. name, { clear = true })
end
local au = vim.api.nvim_create_autocmd

-- Flash what you just yanked, so the copy is visible without checking.
au("TextYankPost", {
  group = augroup("yank_highlight"),
  callback = function() vim.hl.on_yank({ higroup = "IncSearch", timeout = 150 }) end,
})

-- Drop trailing whitespace on save, without moving the cursor.
au("BufWritePre", {
  group = augroup("trim_whitespace"),
  callback = function()
    -- Only real, editable file buffers -- scratch and plugin buffers choke on it.
    if vim.bo.buftype ~= "" or not vim.bo.modifiable then return end
    if vim.bo.filetype == "markdown" or vim.bo.filetype == "diff" then return end
    local view = vim.fn.winsaveview()
    pcall(vim.cmd, [[keeppatterns %s/\s\+$//e]])
    vim.fn.winrestview(view)
  end,
})

-- Reopen a file where you left it.
au("BufReadPost", {
  group = augroup("last_position"),
  callback = function(ev)
    if vim.b[ev.buf].oxblood_seen then return end
    vim.b[ev.buf].oxblood_seen = true
    local exclude = { "gitcommit", "gitrebase", "commit" }
    if vim.tbl_contains(exclude, vim.bo[ev.buf].filetype) then return end
    local mark = vim.api.nvim_buf_get_mark(ev.buf, '"')
    local count = vim.api.nvim_buf_line_count(ev.buf)
    if mark[1] > 0 and mark[1] <= count then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
      vim.cmd("normal! zz")
    end
  end,
})

-- Relative numbers are useful for jumping, noise while reading. Turn them off
-- in insert mode and in unfocused windows.
local numbers = augroup("relative_numbers")
au({ "BufEnter", "FocusGained", "InsertLeave", "WinEnter" }, {
  group = numbers,
  callback = function()
    if vim.wo.number and vim.fn.mode() ~= "i" then vim.wo.relativenumber = true end
  end,
})
au({ "BufLeave", "FocusLost", "InsertEnter", "WinLeave" }, {
  group = numbers,
  callback = function()
    if vim.wo.number then vim.wo.relativenumber = false end
  end,
})

-- q closes throwaway windows; don't list them as buffers you can cycle to.
au("FileType", {
  group = augroup("close_with_q"),
  pattern = {
    "help", "qf", "man", "lspinfo", "checkhealth", "startuptime", "notify",
    "query", "grug-far", "neotest-output", "git", "fugitive", "tsplayground",
  },
  callback = function(ev)
    vim.bo[ev.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = ev.buf, silent = true, desc = "Close" })
  end,
})

-- Open help and man pages in a vertical split; full-width help is hard to read.
au("FileType", {
  group = augroup("vertical_help"),
  pattern = { "help", "man" },
  callback = function()
    if vim.o.columns > 160 then vim.cmd.wincmd("L") end
  end,
})

-- Terminals have no use for gutters.
au("TermOpen", {
  group = augroup("terminal"),
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
    vim.opt_local.spell = false
    vim.opt_local.list = false
  end,
})

-- Prose gets soft wrap and spell check; code does not.
au("FileType", {
  group = augroup("prose"),
  pattern = { "markdown", "text", "gitcommit", "tex", "typst" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
    vim.opt_local.colorcolumn = ""
  end,
})

-- Create the parent directory when saving to a path that doesn't exist yet.
au("BufWritePre", {
  group = augroup("auto_mkdir"),
  callback = function(ev)
    if ev.match:match("^%w%w+://") then return end
    local file = vim.uv.fs_realpath(ev.match) or ev.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- Pick up changes made outside Neovim (git checkout, a formatter, another tool).
au({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup("checktime"),
  callback = function()
    if vim.o.buftype ~= "nofile" then vim.cmd.checktime() end
  end,
})

-- Keep split proportions sane when the terminal is resized.
au("VimResized", {
  group = augroup("resize_splits"),
  callback = function()
    local tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. tab)
  end,
})
