                                                                     # CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal Neovim configuration built on **NvChad** (v2.5 branch) using **lazy.nvim** as the plugin manager. It is not a standalone plugin repo — it's an end-user config meant to be symlinked/cloned to `~/.config/nvim`.

NvChad itself (`NvChad/NvChad`) is pulled in as a plugin and provides the base `options`, `mappings`, `autocmds`, theming (`base46`), and UI (statusline, dashboard, etc.). This repo only overrides/extends what NvChad provides — most files start with `require "nvchad.<module>"` and then append local customizations below.

## Commands

There is no build/lint/test suite — this is an editor config, "testing" means launching Neovim and exercising the config.

- Reload after changes: restart Neovim, or `:source %` on the edited file, or `:Lazy reload <plugin>` for plugin-spec changes.
- Manage plugins: `:Lazy` (open UI), `:Lazy sync` (install/update/clean).
- Manage LSP/DAP/formatter tools: `:Mason`.
- Format a buffer manually: `:ConformInfo` to inspect, format-on-save is enabled by default (see `lua/configs/conform.lua`).
- Lua formatting uses **stylua** (config in `.stylua.toml`: 2-space indent, 120 col width, no parens on zero/one-arg calls). Run `stylua .` to format the config itself.
- Health check: `:checkhealth`.

## Architecture

Entry point is `init.lua`: it sets `mapleader`/`base46_cache`, bootstraps `lazy.nvim`, loads NvChad as a plugin (`import = "nvchad.plugins"`) followed by this repo's own plugins (`import = "plugins"`), applies the cached base46 theme/statusline highlights, then requires `options`, `autocmds`, and (deferred via `vim.schedule`) `mappings`.

Key files under `lua/`:

- `chadrc.lua` — NvChad's own config surface (theme selection, UI overrides). Must match the shape of NvChad's `nvconfig.lua`. Currently just sets `base46.theme = "tokyodark"`.
- `configs/lazy.lua` — lazy.nvim bootstrap options (disabled builtin vim plugins, UI icons).
- `plugins/init.lua` — the single lazy.nvim plugin spec list for everything not covered by NvChad core. Each non-trivial plugin's setup logic lives in its own `configs/<name>.lua` module rather than inline here.
- `configs/lspconfig.lua` — extends `nvchad.configs.lspconfig` defaults, enables servers via `vim.lsp.enable {...}` (currently `html`, `cssls`, `rust`; note Rust LSP is actually driven by rustaceanvim, not plain lspconfig — see below).
- `configs/rustaceanvim.lua` — the real Rust IDE setup: configures `rust-analyzer` (clippy on save, inlay hints, proc-macro/build-script support) and wires the `codelldb` DAP adapter (resolved via `mason-registry`) into `vim.g.rustaceanvim`. Also defines Rust-buffer-local keymaps (`K` hover actions, `<leader>ca/rr/rd/re/rp/rc`) in its `on_attach`.
- `configs/dap.lua` — generic `nvim-dap-ui` + `nvim-dap-virtual-text` wiring, auto-opens/closes the DAP UI on attach/launch/terminate/exit, defines breakpoint/stopped signs.
- `configs/conform.lua` — formatter-by-filetype table (`stylua` for Lua, `rustfmt` for Rust) plus format-on-save options.
- `configs/aerial.lua` — code outline plugin setup with `{`/`}` prev/next symbol jumps and `<leader>a` toggle.
- `mappings.lua` — loads `nvchad.mappings` first, then appends custom keymaps (note: `;` is remapped to `:`, insert-mode `jk` is `<ESC>`, plus the DAP keymaps `<leader>d{b,c,i,o,O,t,u}`).
- `options.lua` / `autocmds.lua` — thin wrappers that `require "nvchad.<module>"` then append local additions. `autocmds.lua` adds a silent autosave on `InsertLeave`/`TextChanged`/`FocusLost` for modifiable, named, normal buffers.

### Adding a new plugin

1. Add its spec to `lua/plugins/init.lua`.
2. If it needs non-trivial setup, put that in `lua/configs/<plugin>.lua` and call it from the spec's `config = function() require "configs.<plugin>" end` (follow the existing pattern used for lspconfig/dap/aerial/rustaceanvim).
3. Keymaps for a plugin's own commands go either in that plugin's `configs/<name>.lua` (if buffer/plugin-scoped, e.g. Rust or Aerial keymaps) or in `lua/mappings.lua` (if global).

### Language tooling currently configured

- **Rust**: rustaceanvim (LSP + DAP), rustfmt (via conform), crates.nvim (Cargo.toml completion/hover), codelldb installed via `mason-tool-installer`.
- **Java**: nvim-java + jdtls.
- **Lua**: stylua formatting, lspconfig `lua_ls` comes from NvChad defaults.
- **HTML/CSS**: lspconfig (`html`, `cssls`).
- Diagnostics/symbols browsing: `trouble.nvim` (`<leader>x*`, `<leader>cs`, `<leader>cl`) and `aerial.nvim` (`<leader>a`).
- Git: `lazygit.nvim` bound to `lg`, integrated with Telescope.
