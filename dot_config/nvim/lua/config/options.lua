local o = vim.opt

-- Leader has to be set before lazy.nvim loads any plugin that maps keys.
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Squared-off borders everywhere Neovim draws a float itself.
vim.o.winborder = "single"

------------------------------------------------------------------ display --
o.number = true
o.relativenumber = true        -- jump distances without counting lines
o.cursorline = true
o.signcolumn = "yes"           -- never let the gutter pop in and shift text
o.colorcolumn = "100"
o.wrap = false
o.linebreak = true             -- if wrap is toggled on, break on words
o.scrolloff = 8
o.sidescrolloff = 8
o.termguicolors = true
o.showmode = false             -- lualine already shows it
o.laststatus = 3               -- one global statusline, not one per split
o.cmdheight = 1
o.pumheight = 12
o.pumblend = 0
o.winblend = 0
o.conceallevel = 0
o.fillchars = {
  eob = " ",                   -- no ~ past the end of the buffer
  fold = " ",
  foldopen = "⌄",
  foldclose = "›",
  foldsep = " ",
  diff = "╱",
  horiz = "─",
  horizup = "┴",
  horizdown = "┬",
  vert = "│",
  vertleft = "┤",
  vertright = "├",
  verthoriz = "┼",
}
o.listchars = { tab = "» ", trail = "·", nbsp = "␣", extends = "›", precedes = "‹" }
o.list = true
o.shortmess:append("sIc")

------------------------------------------------------------------ editing --
o.expandtab = true
o.shiftwidth = 2
o.tabstop = 2
o.softtabstop = 2
o.shiftround = true
o.smartindent = true
o.autoindent = true
o.breakindent = true

------------------------------------------------------------------- search --
o.ignorecase = true
o.smartcase = true             -- ...unless you type a capital
o.hlsearch = true
o.incsearch = true
o.inccommand = "split"         -- live preview of :s

----------------------------------------------------------------- behaviour --
o.mouse = "a"
o.clipboard = "unnamedplus"    -- share the system clipboard
o.splitright = true
o.splitbelow = true
o.splitkeep = "screen"
o.undofile = true
o.undolevels = 10000
o.swapfile = false
o.backup = false
o.writebackup = false
o.updatetime = 200             -- faster CursorHold -> diagnostics, git blame
o.timeoutlen = 400             -- how long which-key waits
o.confirm = true               -- prompt instead of failing on unsaved quit
o.autoread = true
o.completeopt = "menu,menuone,noselect,popup"
o.wildmode = "longest:full,full"
o.jumpoptions = "stack,view"
o.virtualedit = "block"
o.sessionoptions = "buffers,curdir,folds,tabpages,winsize,help"
o.grepprg = "rg --vimgrep --smart-case"
o.grepformat = "%f:%l:%c:%m"

--------------------------------------------------------------------- folds --
o.foldmethod = "expr"
o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
o.foldtext = ""
o.foldlevel = 99               -- everything open on entry
o.foldlevelstart = 99
o.foldnestmax = 4

-- Providers we do not use. Skipping them shaves startup and quiets checkhealth.
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
