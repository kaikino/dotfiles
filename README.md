# dotfiles

Terminal environment, managed with [chezmoi](https://chezmoi.io).
Palette is "Oxblood Navy": one set of 16 ANSI colors defined in
`.config/ghostty/config`; every other tool references ANSI names, so
re-theming means editing that one block.

## New machine

```sh
brew install chezmoi
chezmoi init https://github.com/kaikino/dotfiles.git      # clone, don't apply yet
brew bundle --file="$(chezmoi source-path)/Brewfile"       # every tool, cask, font
chezmoi apply                                              # configs + macOS defaults
```

`Brewfile` is the full package list for this machine (`brew bundle dump`
regenerates it). On Linux, skip the bundle and install the terminal tools
from the distro's packages; the shell config degrades cleanly where one
is missing.

Host-specific aliases (addresses, one-offs) go in `~/.config/zsh/local.zsh`,
which is sourced if present and deliberately not tracked.
