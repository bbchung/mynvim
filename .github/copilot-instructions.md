# Copilot Instructions

## Build, test, and lint commands

This repository is a Lua-based Neovim configuration and does not define a dedicated build system, test suite, or lint script (no `Makefile`, `package.json`, or Lua test harness is present).

- Full configuration smoke test:
  - `nvim --headless '+qa'`
- Single-module check (closest equivalent to a single test):
  - `nvim --headless -u NONE '+luafile lua/plugins/lsp.lua' '+qa'`
  - Replace `lua/plugins/lsp.lua` with the specific Lua file you changed.

## High-level architecture

- `init.lua` is the entrypoint:
  - Sets core Neovim options, diagnostics UI, global keymaps, user commands, and shared autocommands.
  - Loads plugin management via `require("config.lazy")`.
  - Applies the active colorscheme (`everforest`).
- `lua/config/lazy.lua` bootstraps `lazy.nvim` (including cloning it if missing) and imports plugin specs from `lua/plugins`.
- `lua/plugins/*.lua` is organized by feature area; each file returns a plugin spec table:
  - `lsp.lua`: LSP server setup, LSP keymaps, `LspAttach` behavior, and per-server overrides.
  - `autocomplete.lua`: snippet/completion stack (`LuaSnip`, `blink.cmp`, disabled `nvim-cmp` alternative).
  - `tree-sitter.lua`: syntax tree startup, fold/indent integration, textobjects.
  - `diagnostic.lua`: diagnostics display plugins and statusline setup.
  - `fuzzy-search.lua`, `tags.lua`: search/navigation tooling (Telescope, gtags, alternatives disabled).
  - `ai.lua`: assistant plugins (`copilot.vim` enabled, `windsurf.vim` disabled).
  - `colorscheme.lua`, `dashboard.lua`, `edit.lua`, `vcs.lua`, `csv.lua`: UI/theme and editing helpers.

## Key conventions in this codebase

- Plugin definitions follow the same pattern: `return { ...plugin specs... }` under `lua/plugins/`, with feature toggles controlled via `enabled = true/false` for alternatives.
- Quickfix is a primary navigation surface:
  - `<Leader>G`/visual `<Leader>G` use grep over `git ls-files`.
  - `:Diagnostics` pushes all diagnostics to quickfix.
  - `tags.lua` gtags mappings open results in quickfix.
- Diff mode is explicitly handled:
  - `init.lua` clears `readonly` in diff sessions.
  - `lsp.lua` exits early in diff mode to avoid attaching extra LSP behavior.
- `tags.lua` uses a queued singleton async job pattern for `global -u` updates, preventing overlapping gtags update jobs on rapid saves.
- Undo persistence is expected in-repo under `undo/` (`init.lua` creates it; `.gitignore` ignores it).
- Formatting conventions set in `init.lua`: spaces over tabs, width 4 (`expandtab`, `tabstop=4`, `shiftwidth=4`), and these should be preserved when editing Lua config files.
