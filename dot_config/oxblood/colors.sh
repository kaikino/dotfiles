# ══════════════════════════════════════════════════════════════════════
#  Oxblood Navy — the palette as shell variables.
#  ~/.config/ghostty/config is the authority; this mirrors it for anything
#  scripted. Sourced by: ~/.claude/statusline.sh, ~/.config/zsh/theme.zsh
#  (ssh tint), ~/.config/aerospace/aerospace.toml (borders).
#  Can't read it, edit by hand: cmux.json, nvim lua/oxblood/palette.lua.
#  bash/zsh only (substring expansion) — call with `bash -c`, not `sh -c`.
# ══════════════════════════════════════════════════════════════════════
export OX_BG='#0B1020'
export OX_BG_REMOTE='#1A0F12'     # window wash while ssh/mosh is running
export OX_PANEL='#131A2B'         # ansi 0
export OX_RULE='#1E2A45'          # selection, dividers
export OX_DIM='#4A5570'           # ansi 8
export OX_FG='#C6CCDA'            # ansi 7
export OX_BRIGHT='#E6EAF2'        # ansi 15
export OX_RED='#B84A4A'      OX_RED_HI='#E06A6A'
export OX_GREEN='#7FA97E'    OX_GREEN_HI='#9BC498'
export OX_YELLOW='#C7A96B'   OX_YELLOW_HI='#E3C888'
export OX_BLUE='#5680C2'     OX_BLUE_HI='#7AA2E8'
export OX_MAGENTA='#8F6FA8'  OX_MAGENTA_HI='#B191CC'
export OX_CYAN='#5C9FA8'     OX_CYAN_HI='#7FC4CE'
export OX_ORANGE='#C4763C'

# '#B84A4A' -> 0xffB84A4A   (JankyBorders, sketchybar)
ox_argb() { printf '0xff%s' "${1#\#}"; }
# '#B84A4A' -> 184;74;74    (ANSI truecolor escapes)
ox_rgb()  { local h="${1#\#}"; printf '%d;%d;%d' "0x${h:0:2}" "0x${h:2:2}" "0x${h:4:2}"; }
