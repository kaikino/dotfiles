# dotfiles

Terminal environment, managed with [chezmoi](https://chezmoi.io).
Palette is "Oxblood Navy": one set of 16 ANSI colors defined in
`.config/ghostty/config`; every other tool references ANSI names, so
re-theming means editing that one block.

## New machine

```sh
brew install chezmoi starship eza bat git-delta fzf btop lazydocker \
             lazygit ripgrep fd atuin mise gh mosh
brew install --cask font-hack-nerd-font
chezmoi init --apply <repo-url>
```

Host-specific aliases (addresses, one-offs) go in `~/.config/zsh/local.zsh`,
which is sourced if present and deliberately not tracked.
