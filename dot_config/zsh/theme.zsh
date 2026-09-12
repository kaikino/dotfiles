# ══════════════════════════════════════════════════════════════════════
#  Shell theming + tool wiring. Sourced from ~/.zshrc so that file
#  stays short. Everything here is cosmetic or a thin alias — nothing
#  changes what a command actually does.
# ══════════════════════════════════════════════════════════════════════

# One config root. lazygit/lazydocker would otherwise write to
# ~/Library/Application Support on macOS, which doesn't travel.
export XDG_CONFIG_HOME="$HOME/.config"

# ── Runtimes (mise) ───────────────────────────────────────────────────
# Swaps node/python per directory from .tool-versions / .nvmrc etc.
# Java stays with jenv — see ~/.config/mise/config.toml for why.
command -v mise >/dev/null && eval "$(mise activate zsh)"

# ── Prompt ────────────────────────────────────────────────────────────
command -v starship >/dev/null && eval "$(starship init zsh)"

# ── fzf (Ctrl-T files, Alt-C cd) ──────────────────────────────────────
# bg:-1 means "don't paint a background" — the popup inherits the
# window's transparency instead of punching an opaque hole in it.
export FZF_DEFAULT_OPTS="
  --height=45% --layout=reverse --border=sharp --info=inline
  --prompt='> ' --pointer='>' --marker='+'
  --color=fg:-1,bg:-1,hl:1,fg+:15,bg+:0,hl+:9
  --color=info:8,prompt:1,pointer:1,marker:2,spinner:8,header:4,border:8"
if command -v fd >/dev/null; then
  # fd feeds fzf: respects .gitignore, sees dotfiles, skips .git itself.
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND='fd --type d --hidden --exclude .git'
fi
[[ -o interactive && -t 0 ]] && command -v fzf >/dev/null && source <(fzf --zsh)

# ── History (atuin) ───────────────────────────────────────────────────
# Loaded after fzf so atuin wins Ctrl-R. Up-arrow is left alone — plain
# line-by-line recall, no picker popping up uninvited.
[[ -o interactive && -t 0 ]] && command -v atuin >/dev/null && eval "$(atuin init zsh --disable-up-arrow)"

# ── ripgrep ───────────────────────────────────────────────────────────
export RIPGREP_CONFIG_PATH="$HOME/.config/ripgrep/config"

# ── ls → eza ──────────────────────────────────────────────────────────
# Permission bits and timestamps dimmed to grey; filenames keep the color.
export EZA_COLORS="ur=38;5;8:uw=38;5;8:ux=38;5;8:ue=38;5;8:gr=38;5;8:gw=38;5;8:gx=38;5;8:tr=38;5;8:tw=38;5;8:tx=38;5;8:da=38;5;8:uu=38;5;8:gu=38;5;8"
if command -v eza >/dev/null; then
  alias ls='eza --group-directories-first --icons=auto'
  alias ll='eza -l --group-directories-first --icons=auto --git --time-style=long-iso'
  alias la='eza -la --group-directories-first --icons=auto --git --time-style=long-iso'
  alias lt='eza --tree --level=2 --group-directories-first --icons=auto'
fi

# ── cat / man → bat ───────────────────────────────────────────────────
if command -v bat >/dev/null; then
  # A function, not an alias: bat rejects cat's flags, so `cat -v`,
  # `cat -A`, `cat -n` would break. Anything flag-led goes to real cat.
  cat() {
    if [[ $# -gt 0 && "$1" == -* ]]; then
      command cat "$@"
    else
      bat --style=plain "$@"
    fi
  }
  alias catn='bat'                       # with line numbers + git gutter
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
  export MANROFFOPT="-c"
fi

# ── Monitors / TUIs ───────────────────────────────────────────────────
command -v btop >/dev/null && alias top='btop'
command -v lazydocker >/dev/null && alias lzd='lazydocker'
command -v lazygit >/dev/null && alias lg='lazygit'

# yazi, but `q` drops the shell into whatever directory you ended in.
if command -v yazi >/dev/null; then
  y() {
    local tmp cwd
    tmp="$(mktemp -t yazi-cwd.XXXXXX)"
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(command cat -- "$tmp")" && [[ -n "$cwd" && "$cwd" != "$PWD" ]]; then
      builtin cd -- "$cwd"
    fi
    rm -f -- "$tmp"
  }
fi

# ── Docker shorthands ─────────────────────────────────────────────────
# Column layout for `docker ps` lives in ~/.docker/config.json.
alias dps='docker ps'
alias dpsa='docker ps -a'
alias dimg='docker images'
alias dlog='docker logs -f --tail=200'

# ── less ──────────────────────────────────────────────────────────────
export LESS='-R -F -X -i'

# ══════════════════════════════════════════════════════════════════════
#  SSH host tint
#  ssh can't be themed from this side — once you're on the box, its
#  dotfiles own the look. What *is* controllable is the window: the
#  background washes to oxblood for the duration of the session, so
#  "am I local or remote?" is answerable without reading the prompt.
# ══════════════════════════════════════════════════════════════════════
TERM_BG_LOCAL='#0B1020'
TERM_BG_REMOTE='#1A0F12'

term-bg() { printf '\033]11;%s\007' "$1" }
alias term-reset='term-bg "$TERM_BG_LOCAL"'   # manual escape hatch

_remote-tinted() {
  local cmd=$1; shift
  [[ -t 1 ]] || { command "$cmd" "$@"; return }
  term-bg "$TERM_BG_REMOTE"
  {
    command "$cmd" "$@"
  } always {
    term-bg "$TERM_BG_LOCAL"
  }
}
ssh()  { _remote-tinted ssh  "$@" }
mosh() { _remote-tinted mosh "$@" }
