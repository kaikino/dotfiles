# Neovim — Oxblood Navy

Leader is `<Space>`. Press it and pause: **which-key** lists everything
available from there, so this file is a backup, not a prerequisite.

## Layout

```
init.lua              entry point
lua/config/           options, keymaps, autocmds, lazy.nvim bootstrap
lua/plugins/          one file per concern (ui, editor, lsp, treesitter, git)
lua/oxblood/          the palette, mirrored from ~/.config/ghostty/config
colors/               the oxblood-navy colorscheme
after/ftplugin/       per-filetype tweaks (go, python, markdown, make, gitcommit)
```

The colours are the same 16 ANSI slots ghostty defines. Change a hex in
`~/.config/ghostty/config`, mirror it in `lua/oxblood/palette.lua`, and both
stay in step. The background is left unpainted so ghostty's 0.90 opacity and
blur show through — `<leader>ut` toggles that off if it ever gets in the way.

## Getting around

| Key | Does |
| --- | --- |
| `<leader><space>` | Find files (the one to learn first) |
| `<leader>sg` | Grep the whole project |
| `<leader>e` | File tree, toggles |
| `<leader>fb` | Switch buffer |
| `<S-h>` / `<S-l>` | Previous / next buffer |
| `<C-h/j/k/l>` | Move between splits |
| `<leader>-` / `<leader>\|` | Split below / right |
| `<leader>t` | Terminal, toggles |
| `<Esc>` | Clear search highlight |
| `jk` | Leave insert mode |

## Code

| Key | Does |
| --- | --- |
| `gd` `gr` `gI` `gy` | Definition, references, implementations, type |
| `K` | Hover docs |
| `<leader>ca` | Code action |
| `<leader>cr` | Rename symbol |
| `<leader>cf` | Format now (also runs on save) |
| `<leader>cs` | Symbols in this file |
| `]d` `[d` | Next / previous diagnostic |
| `]e` `[e` | Next / previous error |
| `<leader>xd` | Show the diagnostic under the cursor |
| `<C-space>` | Grow selection by syntax node (`<BS>` shrinks) |

Text objects: `af`/`if` function, `ac`/`ic` class, `aa`/`ia` argument,
`ai`/`ii` conditional, `al`/`il` loop, `ih` git hunk.
Surround: `sa` add, `sd` delete, `sr` replace — e.g. `saiw"` quotes a word.

## Git

| Key | Does |
| --- | --- |
| `<leader>gg` | lazygit |
| `]h` `[h` | Next / previous hunk |
| `<leader>ghp` | Preview hunk |
| `<leader>ghs` / `<leader>ghr` | Stage / reset hunk |
| `<leader>gb` | Inline blame, toggles |
| `<leader>gs` | Changed files |

## Search (`<leader>s`)

`sg` grep · `sw` word under cursor · `sb` in this buffer · `sh` help ·
`sk` keymaps · `sd` diagnostics · `st` TODOs · `sR` resume last search

## Toggles (`<leader>u`)

`uw` wrap · `us` spell · `un` line numbers · `ud` diagnostics ·
`uf` format on save · `uh` inlay hints · `ut` transparency

## Housekeeping (`<leader>o`)

`ol` plugins (Lazy) · `om` LSP servers (Mason) · `oc` edit this config ·
`oh` `:checkhealth`

## Adding a language

Add the lspconfig name and its mason package to the `servers` table in
`lua/plugins/lsp.lua`, add a formatter to `formatters_by_ft` in the same file,
and restart. Missing packages install themselves on the next launch.
