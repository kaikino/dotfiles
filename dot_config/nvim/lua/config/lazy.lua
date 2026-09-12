-- Bootstrap lazy.nvim into the data dir on first launch.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  local out = vim.fn.system({
    "git", "clone", "--filter=blob:none", "--branch=stable",
    "https://github.com/folke/lazy.nvim.git", lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" }, { out, "WarningMsg" },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = { { import = "plugins" } },
  defaults = { lazy = true, version = false },
  install = { colorscheme = { "oxblood-navy", "habamax" } },
  checker = { enabled = true, notify = false },   -- check for updates quietly
  rocks = { enabled = false },                   -- nothing here needs luarocks
  change_detection = { notify = false },
  ui = {
    border = "single",                            -- squared, matching everything else
    backdrop = 100,
    icons = { ft = "", lazy = "󰂠 ", loaded = "●", not_loaded = "○" },
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip", "tarPlugin", "tohtml", "tutor", "zipPlugin",
        "rplugin", "netrwPlugin", "matchit", "matchparen",
      },
    },
  },
})
