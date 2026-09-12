# dotfiles

Terminal environment, managed with [chezmoi](https://chezmoi.io).
Palette is "Oxblood Navy": one set of 16 ANSI colors defined in
`.config/ghostty/config`; every other tool references ANSI names, so
re-theming means editing that one block.

## New machine

```sh
brew install chezmoi
chezmoi init https://github.com/kaikino/dotfiles.git   # asks: name, email, work machine?
src="$(chezmoi source-path)"
brew bundle --file="$src/Brewfile"                      # core: safe anywhere
brew bundle --file="$src/Brewfile.desktop"              # AeroSpace, Raycast, cmux — needs Accessibility
brew bundle --file="$src/Brewfile.personal"             # toolchains, Docker/OrbStack, hobbies — NOT for work
chezmoi apply
```

### Work laptop

Answer `y` to "work machine" on init. That makes git commit as the work
identity you enter and skips the macOS defaults script. Bundle **Brewfile**
only, plus **Brewfile.desktop** if IT allows Accessibility permissions.
Leave atuin sync off there — shell history is company data.

On Linux, skip the bundles and install the core tools from the distro's
packages; the shell config degrades cleanly where one is missing.

Host-specific aliases (addresses, one-offs) go in `~/.config/zsh/local.zsh`,
which is sourced if present and deliberately not tracked.
