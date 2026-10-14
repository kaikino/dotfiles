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
brew bundle --file="$src/Brewfile"                      # core: the shell itself. Always.
brew bundle --file="$src/Brewfile.dev"                  # mise, direnv, just, gh, docker CLI, hurl…
brew bundle --file="$src/Brewfile.desktop"              # AeroSpace, Raycast, cmux — needs Accessibility
brew bundle --file="$src/Brewfile.personal"             # toolchains, Docker/OrbStack, hobbies — NOT for work
chezmoi apply
```

The split is by *kind*, not by machine: **core** is personalization only —
prompt, colours, editor, the commands `theme.zsh` aliases to. Nothing in it
is for doing work. The other three are opt-ins.

### Work laptop

Answer `y` to "work machine" on init. That makes git commit as the work
identity you enter and skips the macOS defaults script. Bundle **core**;
add **dev** if the tools are allowed and **desktop** if IT allows
Accessibility permissions. Leave atuin sync off there — shell history is
company data.

### Linux (Ubuntu VM, e.g. GCE)

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b ~/.local/bin init --apply https://github.com/kaikino/dotfiles.git
exec zsh -l
```

`run_onchange_after_linux-core.sh` does the rest: apt prerequisites,
Homebrew on Linux, the core Brewfile (casks filtered out), and `chsh` to
zsh. Homebrew rather than apt because Ubuntu 24.04's nvim (0.9) and fzf
(0.44) are too old for this config. Opt-in bundles the same way:
`grep -v '^cask ' "$(chezmoi source-path)/Brewfile.dev" | brew bundle --file=-`.
AeroSpace, Ghostty and cmux configs aren't installed off macOS.

- **OS Login** accounts aren't in `/etc/passwd`, so `chsh` fails. Instead,
  end `~/.bashrc` with `[[ $- == *i* ]] && command -v zsh >/dev/null && exec zsh -l`.
- **conda**: `conda init` writes into `~/.zshrc`, which chezmoi owns. Put
  `eval "$(~/miniconda3/bin/conda shell.zsh hook)"` in `local.zsh` instead.
- **Terminfo**: once per host, from the Mac:
  `infocmp -x xterm-ghostty | ssh HOST -- tic -x -`. Without it the shell
  falls back to `xterm-256color`.
- **SSH tint** covers `gcloud compute ssh` too.

Host-specific aliases (addresses, one-offs) go in `~/.config/zsh/local.zsh`,
which is sourced if present and deliberately not tracked.
