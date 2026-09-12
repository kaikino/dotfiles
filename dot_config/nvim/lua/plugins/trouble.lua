return {
  -- A real panel for diagnostics, quickfix, references, and symbols,
  -- instead of the bare :copen / :lopen lists. <leader>x is "diagnostics"
  -- already (see keymaps.lua / which-key), so everything lives there.
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (project)" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Diagnostics (buffer)" },
      { "<leader>xs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Symbols (panel)" },
      { "<leader>xr", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "References / definitions" },
      { "<leader>xq", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix list" },
      { "<leader>xl", "<cmd>Trouble loclist toggle<cr>", desc = "Location list" },
      { "]x", function() require("trouble").next({ skip_groups = true, jump = true }) end, desc = "Next trouble item" },
      { "[x", function() require("trouble").prev({ skip_groups = true, jump = true }) end, desc = "Previous trouble item" },
    },
    opts = {
      focus = true,
      warn_no_results = false,
      open_no_results = true,
    },
  },
}
