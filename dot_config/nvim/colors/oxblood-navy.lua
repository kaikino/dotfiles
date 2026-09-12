-- oxblood-navy: a dark navy base with a single oxblood accent.
-- Set `vim.g.oxblood_transparent = false` before `:colorscheme` to paint the
-- background instead of letting the terminal's opacity show through.

vim.cmd.highlight("clear")
if vim.fn.exists("syntax_on") == 1 then
  vim.cmd.syntax("reset")
end
vim.g.colors_name = "oxblood-navy"
vim.o.termguicolors = true
vim.o.background = "dark"

local c = require("oxblood.palette")
local transparent = vim.g.oxblood_transparent ~= false

-- Background used for "the editor itself". NONE lets ghostty's blur through.
local BG = transparent and "NONE" or c.bg
-- Floats and sidebars stay a touch lighter so they read as panes, not holes.
local BG_FLOAT = transparent and "NONE" or c.bg_alt
local BG_SIDE = transparent and "NONE" or c.bg_alt

local hl = function(group, spec) vim.api.nvim_set_hl(0, group, spec) end

local groups = {
  ---------------------------------------------------------------- editor ----
  Normal = { fg = c.fg, bg = BG },
  NormalNC = { fg = c.fg, bg = BG },
  NormalFloat = { fg = c.fg, bg = BG_FLOAT },
  FloatBorder = { fg = c.border, bg = BG_FLOAT },
  FloatTitle = { fg = c.red, bg = BG_FLOAT, bold = true },
  FloatFooter = { fg = c.grey, bg = BG_FLOAT },

  Cursor = { fg = c.bg, bg = c.red },
  lCursor = { fg = c.bg, bg = c.red },
  CursorIM = { fg = c.bg, bg = c.red },
  TermCursor = { fg = c.bg, bg = c.red },
  CursorLine = { bg = c.bg_line },
  CursorColumn = { bg = c.bg_line },
  ColorColumn = { bg = c.bg_alt },
  CursorLineNr = { fg = c.red_br, bold = true },
  LineNr = { fg = c.grey },
  LineNrAbove = { fg = c.grey },
  LineNrBelow = { fg = c.grey },
  SignColumn = { fg = c.grey, bg = BG },
  FoldColumn = { fg = c.grey, bg = BG },
  Folded = { fg = c.fg_dim, bg = c.bg_alt },

  Visual = { bg = c.bg_sel },
  VisualNOS = { bg = c.bg_sel },
  Search = { fg = c.bg, bg = c.yellow },
  IncSearch = { fg = c.bg, bg = c.red_br, bold = true },
  CurSearch = { fg = c.bg, bg = c.red_br, bold = true },
  Substitute = { fg = c.bg, bg = c.red },
  MatchParen = { fg = c.red_br, bold = true, underline = true },

  -- Squared TUI split lines, not a heavy wall.
  WinSeparator = { fg = c.border, bg = BG },
  VertSplit = { fg = c.border, bg = BG },

  Pmenu = { fg = c.fg, bg = c.bg_alt },
  PmenuSel = { fg = c.fg_bright, bg = c.bg_sel, bold = true },
  PmenuKind = { fg = c.cyan, bg = c.bg_alt },
  PmenuKindSel = { fg = c.cyan_br, bg = c.bg_sel },
  PmenuExtra = { fg = c.grey, bg = c.bg_alt },
  PmenuExtraSel = { fg = c.fg_dim, bg = c.bg_sel },
  PmenuSbar = { bg = c.bg_alt },
  PmenuThumb = { bg = c.border },
  PmenuMatch = { fg = c.red_br, bold = true },
  PmenuMatchSel = { fg = c.red_br, bg = c.bg_sel, bold = true },
  WildMenu = { fg = c.bg, bg = c.red },

  StatusLine = { fg = c.fg, bg = c.bg_alt },
  StatusLineNC = { fg = c.grey, bg = BG },
  TabLine = { fg = c.grey, bg = c.bg_alt },
  TabLineSel = { fg = c.fg_bright, bg = BG, bold = true },
  TabLineFill = { bg = BG },
  WinBar = { fg = c.fg_dim, bg = BG, bold = true },
  WinBarNC = { fg = c.grey, bg = BG },

  MsgArea = { fg = c.fg },
  MsgSeparator = { fg = c.border },
  ModeMsg = { fg = c.fg_bright, bold = true },
  MoreMsg = { fg = c.green },
  Question = { fg = c.blue_br },
  ErrorMsg = { fg = c.red_br, bold = true },
  WarningMsg = { fg = c.yellow },
  Directory = { fg = c.blue_br },
  Title = { fg = c.red, bold = true },
  Conceal = { fg = c.grey },
  NonText = { fg = c.grey },
  SpecialKey = { fg = c.grey },
  Whitespace = { fg = "#232C42" },
  EndOfBuffer = { fg = BG == "NONE" and c.bg or BG },
  QuickFixLine = { bg = c.bg_sel, bold = true },
  SnippetTabstop = { bg = c.bg_sel },

  SpellBad = { sp = c.red_br, undercurl = true },
  SpellCap = { sp = c.yellow, undercurl = true },
  SpellLocal = { sp = c.cyan, undercurl = true },
  SpellRare = { sp = c.magenta, undercurl = true },

  ---------------------------------------------------------------- syntax ----
  Comment = { fg = c.grey, italic = true },
  Constant = { fg = c.cyan_br },
  String = { fg = c.green },
  Character = { fg = c.green_br },
  Number = { fg = c.magenta_br },
  Boolean = { fg = c.magenta_br },
  Float = { fg = c.magenta_br },

  Identifier = { fg = c.fg },
  Function = { fg = c.blue_br },

  Statement = { fg = c.red },
  Conditional = { fg = c.red },
  Repeat = { fg = c.red },
  Label = { fg = c.red },
  Operator = { fg = c.cyan },
  Keyword = { fg = c.red },
  Exception = { fg = c.red_br },

  PreProc = { fg = c.magenta },
  Include = { fg = c.magenta },
  Define = { fg = c.magenta },
  Macro = { fg = c.magenta },
  PreCondit = { fg = c.magenta },

  Type = { fg = c.yellow },
  StorageClass = { fg = c.yellow },
  Structure = { fg = c.yellow },
  Typedef = { fg = c.yellow },

  Special = { fg = c.cyan_br },
  SpecialChar = { fg = c.yellow_br },
  Tag = { fg = c.red },
  Delimiter = { fg = c.fg_dim },
  SpecialComment = { fg = c.fg_dim, italic = true },
  Debug = { fg = c.red_br },

  Underlined = { underline = true },
  Bold = { bold = true },
  Italic = { italic = true },
  Ignore = { fg = c.grey },
  Error = { fg = c.red_br },
  Todo = { fg = c.bg, bg = c.yellow, bold = true },
  Added = { fg = c.green },
  Changed = { fg = c.blue_br },
  Removed = { fg = c.red_br },

  ------------------------------------------------------------ treesitter ----
  ["@variable"] = { fg = c.fg },
  ["@variable.builtin"] = { fg = c.red_br, italic = true },
  ["@variable.parameter"] = { fg = c.fg_dim },
  ["@variable.member"] = { fg = c.cyan_br },
  ["@constant"] = { fg = c.cyan_br },
  ["@constant.builtin"] = { fg = c.magenta_br },
  ["@constant.macro"] = { fg = c.magenta },
  ["@module"] = { fg = c.yellow },
  ["@label"] = { fg = c.red },

  ["@string"] = { fg = c.green },
  ["@string.documentation"] = { fg = c.green, italic = true },
  ["@string.escape"] = { fg = c.yellow_br },
  ["@string.regexp"] = { fg = c.yellow_br },
  ["@string.special"] = { fg = c.cyan_br },
  ["@string.special.url"] = { fg = c.cyan, underline = true },
  ["@character"] = { fg = c.green_br },
  ["@number"] = { fg = c.magenta_br },
  ["@boolean"] = { fg = c.magenta_br },
  ["@float"] = { fg = c.magenta_br },

  ["@function"] = { fg = c.blue_br },
  ["@function.builtin"] = { fg = c.cyan_br },
  ["@function.macro"] = { fg = c.magenta },
  ["@function.method"] = { fg = c.blue_br },
  ["@constructor"] = { fg = c.yellow },
  ["@operator"] = { fg = c.cyan },

  ["@keyword"] = { fg = c.red },
  ["@keyword.function"] = { fg = c.red },
  ["@keyword.operator"] = { fg = c.red },
  ["@keyword.return"] = { fg = c.red_br },
  ["@keyword.import"] = { fg = c.magenta },
  ["@keyword.exception"] = { fg = c.red_br },
  ["@keyword.conditional"] = { fg = c.red },
  ["@keyword.repeat"] = { fg = c.red },

  ["@type"] = { fg = c.yellow },
  ["@type.builtin"] = { fg = c.yellow, italic = true },
  ["@type.definition"] = { fg = c.yellow },
  ["@attribute"] = { fg = c.magenta },
  ["@property"] = { fg = c.cyan_br },

  ["@punctuation.delimiter"] = { fg = c.fg_dim },
  ["@punctuation.bracket"] = { fg = c.fg_dim },
  ["@punctuation.special"] = { fg = c.cyan },

  ["@comment"] = { fg = c.grey, italic = true },
  ["@comment.error"] = { fg = c.bg, bg = c.red, bold = true },
  ["@comment.warning"] = { fg = c.bg, bg = c.yellow, bold = true },
  ["@comment.todo"] = { fg = c.bg, bg = c.cyan, bold = true },
  ["@comment.note"] = { fg = c.bg, bg = c.blue_br, bold = true },

  ["@tag"] = { fg = c.red },
  ["@tag.builtin"] = { fg = c.red },
  ["@tag.attribute"] = { fg = c.yellow },
  ["@tag.delimiter"] = { fg = c.fg_dim },

  ["@markup.heading"] = { fg = c.red, bold = true },
  ["@markup.heading.1"] = { fg = c.red_br, bold = true },
  ["@markup.heading.2"] = { fg = c.yellow_br, bold = true },
  ["@markup.heading.3"] = { fg = c.blue_br, bold = true },
  ["@markup.heading.4"] = { fg = c.cyan_br, bold = true },
  ["@markup.strong"] = { bold = true },
  ["@markup.italic"] = { italic = true },
  ["@markup.strikethrough"] = { strikethrough = true },
  ["@markup.underline"] = { underline = true },
  ["@markup.link"] = { fg = c.blue_br },
  ["@markup.link.url"] = { fg = c.cyan, underline = true },
  ["@markup.link.label"] = { fg = c.cyan_br },
  ["@markup.raw"] = { fg = c.green },
  ["@markup.raw.block"] = { fg = c.green },
  ["@markup.list"] = { fg = c.red },
  ["@markup.list.checked"] = { fg = c.green },
  ["@markup.list.unchecked"] = { fg = c.grey },
  ["@markup.quote"] = { fg = c.fg_dim, italic = true },

  ["@diff.plus"] = { fg = c.green },
  ["@diff.minus"] = { fg = c.red_br },
  ["@diff.delta"] = { fg = c.blue_br },

  ------------------------------------------------------------------- lsp ----
  ["@lsp.type.namespace"] = { link = "@module" },
  ["@lsp.type.type"] = { link = "@type" },
  ["@lsp.type.class"] = { link = "@type" },
  ["@lsp.type.enum"] = { link = "@type" },
  ["@lsp.type.interface"] = { link = "@type" },
  ["@lsp.type.struct"] = { link = "@type" },
  ["@lsp.type.parameter"] = { link = "@variable.parameter" },
  ["@lsp.type.variable"] = { link = "@variable" },
  ["@lsp.type.property"] = { link = "@property" },
  ["@lsp.type.enumMember"] = { link = "@constant" },
  ["@lsp.type.function"] = { link = "@function" },
  ["@lsp.type.method"] = { link = "@function.method" },
  ["@lsp.type.macro"] = { link = "@function.macro" },
  ["@lsp.type.decorator"] = { link = "@attribute" },
  ["@lsp.type.comment"] = {},
  ["@lsp.mod.readonly"] = { link = "@constant" },
  ["@lsp.mod.deprecated"] = { strikethrough = true },

  LspReferenceText = { bg = c.bg_sel },
  LspReferenceRead = { bg = c.bg_sel },
  LspReferenceWrite = { bg = c.bg_sel, underline = true },
  LspSignatureActiveParameter = { fg = c.red_br, bold = true },
  LspInlayHint = { fg = c.grey, bg = c.bg_alt, italic = true },
  LspCodeLens = { fg = c.grey, italic = true },
  LspInfoBorder = { fg = c.border },

  ----------------------------------------------------------- diagnostics ----
  DiagnosticError = { fg = c.red_br },
  DiagnosticWarn = { fg = c.yellow },
  DiagnosticInfo = { fg = c.blue_br },
  DiagnosticHint = { fg = c.cyan },
  DiagnosticOk = { fg = c.green },
  DiagnosticUnderlineError = { sp = c.red_br, undercurl = true },
  DiagnosticUnderlineWarn = { sp = c.yellow, undercurl = true },
  DiagnosticUnderlineInfo = { sp = c.blue_br, undercurl = true },
  DiagnosticUnderlineHint = { sp = c.cyan, undercurl = true },
  DiagnosticUnderlineOk = { sp = c.green, undercurl = true },
  DiagnosticVirtualTextError = { fg = c.red, bg = c.diff_del },
  DiagnosticVirtualTextWarn = { fg = c.yellow, bg = "#241E12" },
  DiagnosticVirtualTextInfo = { fg = c.blue, bg = c.diff_chg },
  DiagnosticVirtualTextHint = { fg = c.cyan, bg = "#13232A" },
  DiagnosticUnnecessary = { fg = c.grey, italic = true },
  DiagnosticDeprecated = { fg = c.grey, strikethrough = true },

  ------------------------------------------------------------------ diff ----
  DiffAdd = { bg = c.diff_add },
  DiffDelete = { bg = c.diff_del, fg = c.red },
  DiffChange = { bg = c.diff_chg },
  DiffText = { bg = c.diff_text },
  diffAdded = { fg = c.green },
  diffRemoved = { fg = c.red_br },
  diffChanged = { fg = c.blue_br },
  diffFile = { fg = c.yellow },
  diffLine = { fg = c.grey },
  diffIndexLine = { fg = c.magenta },

  --------------------------------------------------------------- plugins ----
  -- gitsigns
  GitSignsAdd = { fg = c.green },
  GitSignsChange = { fg = c.blue },
  GitSignsDelete = { fg = c.red },
  GitSignsAddLn = { bg = c.diff_add },
  GitSignsChangeLn = { bg = c.diff_chg },
  GitSignsDeleteLn = { bg = c.diff_del },
  GitSignsCurrentLineBlame = { fg = c.grey, italic = true },
  GitSignsAddInline = { bg = "#1E3A28" },
  GitSignsDeleteInline = { bg = "#42222A" },
  GitSignsChangeInline = { bg = c.diff_text },

  -- telescope
  TelescopeNormal = { fg = c.fg, bg = BG_FLOAT },
  TelescopeBorder = { fg = c.border, bg = BG_FLOAT },
  TelescopeTitle = { fg = c.bg, bg = c.red, bold = true },
  TelescopePromptNormal = { fg = c.fg_bright, bg = BG_FLOAT },
  TelescopePromptBorder = { fg = c.border, bg = BG_FLOAT },
  TelescopePromptTitle = { fg = c.bg, bg = c.red, bold = true },
  TelescopePromptPrefix = { fg = c.red_br },
  TelescopePromptCounter = { fg = c.grey },
  TelescopeResultsTitle = { fg = c.bg, bg = c.blue, bold = true },
  TelescopePreviewTitle = { fg = c.bg, bg = c.cyan, bold = true },
  TelescopeSelection = { fg = c.fg_bright, bg = c.bg_sel, bold = true },
  TelescopeSelectionCaret = { fg = c.red_br, bg = c.bg_sel, bold = true },
  TelescopeMultiSelection = { fg = c.yellow_br },
  TelescopeMatching = { fg = c.red_br, bold = true },
  TelescopeResultsComment = { fg = c.grey },

  -- blink.cmp
  BlinkCmpMenu = { fg = c.fg, bg = c.bg_alt },
  BlinkCmpMenuBorder = { fg = c.border, bg = c.bg_alt },
  BlinkCmpMenuSelection = { fg = c.fg_bright, bg = c.bg_sel, bold = true },
  BlinkCmpScrollBarThumb = { bg = c.border },
  BlinkCmpScrollBarGutter = { bg = c.bg_alt },
  BlinkCmpLabel = { fg = c.fg },
  BlinkCmpLabelDeprecated = { fg = c.grey, strikethrough = true },
  BlinkCmpLabelMatch = { fg = c.red_br, bold = true },
  BlinkCmpLabelDetail = { fg = c.grey },
  BlinkCmpLabelDescription = { fg = c.grey },
  BlinkCmpKind = { fg = c.cyan },
  BlinkCmpSource = { fg = c.grey },
  BlinkCmpGhostText = { fg = c.grey, italic = true },
  BlinkCmpDoc = { fg = c.fg, bg = c.bg_alt },
  BlinkCmpDocBorder = { fg = c.border, bg = c.bg_alt },
  BlinkCmpDocSeparator = { fg = c.border, bg = c.bg_alt },
  BlinkCmpSignatureHelp = { fg = c.fg, bg = c.bg_alt },
  BlinkCmpSignatureHelpBorder = { fg = c.border, bg = c.bg_alt },
  BlinkCmpSignatureHelpActiveParameter = { fg = c.red_br, bold = true },

  -- neo-tree
  NeoTreeNormal = { fg = c.fg, bg = BG_SIDE },
  NeoTreeNormalNC = { fg = c.fg_dim, bg = BG_SIDE },
  NeoTreeWinSeparator = { fg = c.border, bg = BG_SIDE },
  NeoTreeEndOfBuffer = { fg = BG_SIDE == "NONE" and c.bg or BG_SIDE, bg = BG_SIDE },
  NeoTreeRootName = { fg = c.red, bold = true },
  NeoTreeDirectoryName = { fg = c.blue_br },
  NeoTreeDirectoryIcon = { fg = c.blue },
  NeoTreeFileName = { fg = c.fg },
  NeoTreeFileNameOpened = { fg = c.fg_bright, bold = true },
  NeoTreeIndentMarker = { fg = "#243050" },
  NeoTreeExpander = { fg = c.grey },
  NeoTreeCursorLine = { bg = c.bg_sel },
  NeoTreeTitleBar = { fg = c.bg, bg = c.red },
  NeoTreeFloatBorder = { fg = c.border, bg = BG_FLOAT },
  NeoTreeFloatTitle = { fg = c.red, bg = BG_FLOAT, bold = true },
  NeoTreeGitAdded = { fg = c.green },
  NeoTreeGitModified = { fg = c.blue_br },
  NeoTreeGitDeleted = { fg = c.red_br },
  NeoTreeGitUntracked = { fg = c.yellow },
  NeoTreeGitIgnored = { fg = c.grey },
  NeoTreeGitConflict = { fg = c.red_br, bold = true },
  NeoTreeModified = { fg = c.yellow },
  NeoTreeDimText = { fg = c.grey },
  NeoTreeMessage = { fg = c.grey, italic = true },

  -- which-key
  WhichKey = { fg = c.red_br, bold = true },
  WhichKeyGroup = { fg = c.blue_br },
  WhichKeyDesc = { fg = c.fg },
  WhichKeySeparator = { fg = c.grey },
  WhichKeyFloat = { bg = BG_FLOAT },
  WhichKeyBorder = { fg = c.border, bg = BG_FLOAT },
  WhichKeyTitle = { fg = c.red, bg = BG_FLOAT, bold = true },
  WhichKeyValue = { fg = c.grey },
  WhichKeyIcon = { fg = c.cyan },
  WhichKeyIconAzure = { fg = c.blue_br },
  WhichKeyIconBlue = { fg = c.blue },
  WhichKeyIconCyan = { fg = c.cyan },
  WhichKeyIconGreen = { fg = c.green },
  WhichKeyIconGrey = { fg = c.grey },
  WhichKeyIconOrange = { fg = c.yellow },
  WhichKeyIconPurple = { fg = c.magenta },
  WhichKeyIconRed = { fg = c.red_br },
  WhichKeyIconYellow = { fg = c.yellow_br },
  WhichKeyNormal = { bg = BG_FLOAT },

  -- indent-blankline
  IblIndent = { fg = "#1B2540" },
  IblScope = { fg = "#33405F" },
  IblWhitespace = { fg = "#1B2540" },

  -- bufferline
  BufferLineFill = { bg = BG },
  BufferLineBackground = { fg = c.grey, bg = BG },
  BufferLineBufferSelected = { fg = c.fg_bright, bg = BG, bold = true },
  BufferLineBufferVisible = { fg = c.fg_dim, bg = BG },
  BufferLineSeparator = { fg = c.border, bg = BG },
  BufferLineSeparatorSelected = { fg = c.border, bg = BG },
  BufferLineSeparatorVisible = { fg = c.border, bg = BG },
  BufferLineIndicatorSelected = { fg = c.red, bg = BG },
  BufferLineModified = { fg = c.yellow, bg = BG },
  BufferLineModifiedSelected = { fg = c.yellow_br, bg = BG },
  BufferLineModifiedVisible = { fg = c.yellow, bg = BG },
  BufferLineCloseButton = { fg = c.grey, bg = BG },
  BufferLineCloseButtonSelected = { fg = c.red_br, bg = BG },
  BufferLineError = { fg = c.red_br, bg = BG },
  BufferLineErrorSelected = { fg = c.red_br, bg = BG, bold = true },
  BufferLineWarning = { fg = c.yellow, bg = BG },
  BufferLineWarningSelected = { fg = c.yellow_br, bg = BG, bold = true },
  BufferLineNumbers = { fg = c.grey, bg = BG },
  BufferLineNumbersSelected = { fg = c.fg_bright, bg = BG, bold = true },
  BufferLineOffsetSeparator = { fg = c.border, bg = BG },

  -- mini.nvim
  MiniIndentscopeSymbol = { fg = "#33405F" },
  MiniStatuslineModeNormal = { fg = c.bg, bg = c.blue_br, bold = true },
  MiniSurround = { fg = c.bg, bg = c.red },

  -- flash / misc
  FlashLabel = { fg = c.bg, bg = c.red_br, bold = true },
  NotifyBackground = { bg = c.bg_alt },
  RainbowDelimiterRed = { fg = c.red_br },
  RainbowDelimiterYellow = { fg = c.yellow },
  RainbowDelimiterBlue = { fg = c.blue_br },
  RainbowDelimiterCyan = { fg = c.cyan },
  RainbowDelimiterViolet = { fg = c.magenta_br },
  RainbowDelimiterGreen = { fg = c.green },
  RainbowDelimiterOrange = { fg = c.yellow_br },
}

for group, spec in pairs(groups) do
  hl(group, spec)
end

-- Terminal colours inside :terminal mirror the ghostty ANSI slots exactly.
vim.g.terminal_color_0 = c.bg_alt
vim.g.terminal_color_1 = c.red
vim.g.terminal_color_2 = c.green
vim.g.terminal_color_3 = c.yellow
vim.g.terminal_color_4 = c.blue
vim.g.terminal_color_5 = c.magenta
vim.g.terminal_color_6 = c.cyan
vim.g.terminal_color_7 = c.fg
vim.g.terminal_color_8 = c.grey
vim.g.terminal_color_9 = c.red_br
vim.g.terminal_color_10 = c.green_br
vim.g.terminal_color_11 = c.yellow_br
vim.g.terminal_color_12 = c.blue_br
vim.g.terminal_color_13 = c.magenta_br
vim.g.terminal_color_14 = c.cyan_br
vim.g.terminal_color_15 = c.fg_bright
