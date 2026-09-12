#!/bin/bash
# ─────────────────────────────────────────────────────────────────────
#  Claude Code statusline — Oxblood Navy
#  Palette matches ~/.config/ghostty/config so the row reads as part of
#  the terminal, not a widget pasted on top of it.
#  Truecolor escapes are used deliberately: they survive any theme.
# ─────────────────────────────────────────────────────────────────────
input=$(cat)

# One jq pass — this runs on every render, so it stays cheap.
# Fields are joined with US (0x1f) rather than tab: tab is IFS-whitespace,
# so bash would silently collapse empty fields and shift everything left.
US=$'\x1f'
IFS="$US" read -r MODEL EFFORT PCT WINDOW ADDED REMOVED COST DIR WT PR RL5 FAST <<<"$(
  printf '%s' "$input" | jq -j '
    [ (.model.display_name // "claude"),
      (.effort.level // ""),
      (.context_window.used_percentage // 0 | floor | tostring),
      (.context_window.context_window_size // 200000 | tostring),
      (.cost.total_lines_added // 0 | tostring),
      (.cost.total_lines_removed // 0 | tostring),
      (.cost.total_cost_usd // 0 | tostring),
      (.workspace.current_dir // .cwd // ""),
      (.worktree.name // .workspace.git_worktree // ""),
      (.pr.number // "" | tostring),
      (.rate_limits.five_hour.used_percentage // 0 | floor | tostring),
      (if .fast_mode then "1" else "" end)
    ] | join("")' 2>/dev/null
)"

# Anything that reaches an arithmetic test gets pinned to a number first.
num() { case "$1" in ''|*[!0-9]*) echo 0 ;; *) echo "$1" ;; esac; }
PCT=$(num "$PCT"); WINDOW=$(num "$WINDOW"); RL5=$(num "$RL5")
ADDED=$(num "$ADDED"); REMOVED=$(num "$REMOVED")
case "$COST" in ''|*[!0-9.]*) COST=0 ;; esac

# ── Palette ──────────────────────────────────────────────────────────
c() { printf '\033[38;2;%sm' "$1"; }
DIM=$(c '74;85;112')      # comment grey — structure, never content
BLUE=$(c '122;162;232')
PURPLE=$(c '177;145;204')
GREEN=$(c '155;196;152')
YELLOW=$(c '227;200;136')
ORANGE=$(c '196;118;60')
RED=$(c '224;106;106')
TEAL=$(c '127;218;206')
R=$(printf '\033[0m')

out=""
sep="${DIM}   ${R}"   # spacing, not pipes — the eye groups by color instead

# ── Location: only what cmux's sidebar does NOT already show ─────────
branch=$(git -C "$DIR" rev-parse --abbrev-ref HEAD 2>/dev/null)
if [ -n "$branch" ]; then
  dirty=""
  [ -n "$(git -C "$DIR" status --porcelain -uno 2>/dev/null | head -c 1)" ] && dirty="${YELLOW}*${R}"
  [ -n "$WT" ] && branch="${WT} ⊂ ${branch}"
  out+="${DIM}${branch}${R}${dirty}"
  [ -n "$PR" ] && out+=" ${DIM}#${PR}${R}"
  out+="$sep"
fi

# ── Model ────────────────────────────────────────────────────────────
out+="${BLUE}${MODEL}${R}"
[ -n "$FAST" ] && out+=" ${YELLOW}⚡${R}"
[ -n "$EFFORT" ] && out+=" ${DIM}·${R} ${PURPLE}${EFFORT}${R}"
out+="$sep"

# ── Context bar: the number you actually steer by ────────────────────
# Color is the signal; the bar is just a faster way to read the number.
if   [ "$PCT" -ge 90 ]; then bar=$RED
elif [ "$PCT" -ge 75 ]; then bar=$ORANGE
elif [ "$PCT" -ge 50 ]; then bar=$YELLOW
else                         bar=$GREEN
fi
cells=10
fill=$(( (PCT * cells + 50) / 100 ))
[ "$fill" -gt "$cells" ] && fill=$cells
[ "$fill" -lt 0 ] && fill=0
on=""; off=""
for ((i=0; i<fill; i++));     do on+="▰"; done
for ((i=fill; i<cells; i++)); do off+="▱"; done
out+="${bar}${on}${DIM}${off}${R} ${bar}${PCT}%${R}"
[ "$WINDOW" -ge 1000000 ] && out+=" ${DIM}1M${R}"
out+="$sep"

# ── Session churn ────────────────────────────────────────────────────
if [ "$ADDED" -gt 0 ] || [ "$REMOVED" -gt 0 ]; then
  out+="${GREEN}+${ADDED}${R} ${RED}−${REMOVED}${R}${sep}"
fi

# ── Cost ─────────────────────────────────────────────────────────────
out+=$(printf "${TEAL}\$%.2f${R}" "$COST")

# ── Rate limit: silent until it matters ──────────────────────────────
if [ "$RL5" -ge 70 ]; then
  lim=$YELLOW; [ "$RL5" -ge 90 ] && lim=$RED
  out+="${sep}${lim}${RL5}% 5h${R}"
fi

printf '%s\n' "$out"
