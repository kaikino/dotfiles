-- ~/.config/nvim -- Oxblood Navy
--
-- Layout:
--   lua/config/   options, keymaps, autocmds, plugin-manager bootstrap
--   lua/plugins/  one file per concern; lazy.nvim imports them all
--   colors/       the oxblood-navy colorscheme (mirrors the ghostty palette)
--
-- Leader is <Space>. Press it and wait: which-key lists what's available.

require("config.options")

-- Transparency on by default: ghostty is already running at 0.90 with blur,
-- and painting our own background would cancel it out. <leader>ut toggles.
vim.g.oxblood_transparent = true

require("config.lazy")

vim.cmd.colorscheme("oxblood-navy")
require("config.keymaps")
require("config.autocmds")
