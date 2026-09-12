-- Oxblood Navy -- mirrors the 16 ANSI slots in ~/.config/ghostty/config.
-- Edit there first, then mirror here so the whole machine stays in step.
return {
  bg         = "#0B1020", -- ghostty background
  bg_alt     = "#131A2B", -- ANSI 0  (floats, sidebar)
  bg_line    = "#161E33", -- cursorline
  bg_sel     = "#1E2A45", -- ghostty selection-background
  border     = "#2A3651",
  grey       = "#4A5570", -- ANSI 8  (comments, line numbers)
  fg_dim     = "#8791A8",
  fg         = "#C6CCDA", -- ANSI 7 / ghostty foreground
  fg_bright  = "#E6EAF2", -- ANSI 15
  red        = "#B84A4A", -- ANSI 1  -- the single loud accent
  red_br     = "#E06A6A", -- ANSI 9
  green      = "#7FA97E", -- ANSI 2
  green_br   = "#9BC498", -- ANSI 10
  yellow     = "#C7A96B", -- ANSI 3
  yellow_br  = "#E3C888", -- ANSI 11
  blue       = "#5680C2", -- ANSI 4
  blue_br    = "#7AA2E8", -- ANSI 12
  magenta    = "#8F6FA8", -- ANSI 5
  magenta_br = "#B191CC", -- ANSI 13
  cyan       = "#5C9FA8", -- ANSI 6
  cyan_br    = "#7FC4CE", -- ANSI 14
  -- diff / git washes, kept close to the navy base
  diff_add   = "#16241C",
  diff_del   = "#2A1618",
  diff_chg   = "#151F33",
  diff_text  = "#1F2F4A",
}
