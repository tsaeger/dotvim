# Tom's Neovim 2026

A standalone Nix flake providing a Neovim **runtime** (the editor binary plus
always-needed "Tier-1" tools) and a home-manager module. The Neovim *config* is
a live git checkout you edit in place: **Nix owns the runtime, git owns the
config.**

[NVIM_APPNAME](https://neovim.io/doc/user/starting.html#%24NVIM_APPNAME) =
`nvim2026` isolates this install — config at `~/.config/nvim2026`, data/state at
`~/.local/{share,state}/nvim2026`. neovim v0.12.0+ is required (the flake pins a
compatible build).

## Architecture

Three tiers, three independent update cadences:

- **Tier 1 — Nix flake** (`nix/package.nix`): always-needed tools, pinned, on
  PATH inside *and* outside nvim (ripgrep, fd, tree-sitter, gcc, node, python
  3.13, a Python dev toolchain, rust-analyzer from fenix, plus core
  formatters/linters). `lua/core/tools.lua` is the single source of truth for tool
  ownership.
- **Tier 2 — mason**: experimental / language-specific / short-lived tools.
- **Plugins — lazy.nvim**: all plugins, pinned in the committed `lazy-lock.json`.
  Bump deliberately with `:Lazy update`, then commit the lockfile — the same
  cadence as `nix flake update`. (Floating plugins is what bit older configs when
  upstreams dropped nvim 0.12-removed APIs.)

Run `:checkhealth dotvim` (or `:DotvimDoctor`) inside nvim to verify each tool
resolves where the registry says (nix-store / mason / system) and flag any PATH
shadowing.

### Eval loop

Two complementary gates keep the config from silently breaking:

- `:checkhealth dotvim` / `:DotvimDoctor` — manual, inside nvim: registry
  (`lua/core/tools.lua`) vs reality. Both render the same audit (`tools.audit()`);
  checkhealth uses the native health UI, DotvimDoctor a scratch buffer.
- `test/smoke.sh` — automated: boots the config headless against the committed
  `lazy-lock.json`, loads every plugin, and fails on any Lua error or
  deprecation. Runs in CI (`.github/workflows/ci.yml`) alongside `nix flake
  check`. Run locally with `NVIM=$(nix build .#nvim --print-out-paths)/bin/nvim
  test/smoke.sh`.

## Install

### Try the runtime

```bash
nix run github:tsaeger/dotvim#nvim
```

`NVIM_APPNAME=nvim2026` is baked in, so clone the config first (below) for it to
have something to load.

### Get the config (the live checkout you edit)

```bash
git clone -b nvim2026 https://github.com/tsaeger/dotvim.git ~/.config/nvim2026
```

Plugins install on first launch (lazy.nvim); Tier-2 tools install via mason.

### Via home-manager (recommended)

```nix
{
  inputs.dotvim.url = "github:tsaeger/dotvim/nvim2026";

  # in your home-manager configuration:
  imports = [ inputs.dotvim.homeManagerModules.default ];
  programs.dotvim = {
    enable = true;
    # toolsPath = "var";       # set $DOTVIM_TOOLS_BIN; you place it in PATH (default)
    # toolsPath = "profile";   # prepend Tier-1 tools to the home-manager profile PATH
    # bootstrapConfig = true;  # git-clone the config on first activation if absent
    # neovide.enable = true;   # also install the Neovide GUI (see below)
  };
}
```

The module installs only the runtime. With the default `toolsPath = "var"`, add
the Tier-1 tools to your shell PATH wherever you want them in the ordering:

```sh
export PATH="$DOTVIM_TOOLS_BIN:$PATH"   # prefix — dotvim tools win
```

### Neovide (GUI) alongside terminal nvim

Set `programs.dotvim.neovide.enable = true`. Both the terminal `nvim` and the
GUI use the **same** wrapped runtime — Neovide is built with `--neovim-bin`
baked in, pointing at the dotvim nvim, so it launches with
`NVIM_APPNAME=nvim2026` and the Tier-1 tools on PATH even when started from
Spotlight/Dock (which don't inherit your shell `$PATH`). On macOS this installs
`Neovide.app` (home-manager links it into *~/Applications/Home Manager Apps*).

Enabling it also:

- **Installs a Nerd Font** (`nerd-fonts.meslo-lg` by default) and, on macOS,
  symlinks it into *~/Library/Fonts* so the GUI can find it.
- **Points Neovide at that font** by writing *~/.config/neovide/config.toml*.
- **Uses a custom app icon**: the official Neovim mark with a large `2026`
  overlay, generated in the flake (`nix/icon.nix`).

```nix
programs.dotvim.neovide = {
  enable = true;
  # font = "MesloLGM Nerd Font";   # any family from fontPackage
  # fontSize = 14.0;
  # fontPackage = pkgs.nerd-fonts.jetbrains-mono;   # swap the Nerd Font
  # manageConfig = false;          # stop managing config.toml yourself
};
```

The icon label defaults to `2026`; override it where the flake builds the
package, e.g. `packages.<sys>.neovide = pkgs.callPackage ./nix/neovide.nix {
inherit nvim; iconLabel = "2027"; }`.

Run it ad-hoc without installing: `nix run github:tsaeger/dotvim#neovide`.

### Tier-1 tools on PATH without nvim

```bash
nix profile install github:tsaeger/dotvim#tools
```

## Promoting a tool from mason to Tier-1

1. add the nixpkgs attr to `runtimeDeps` in `nix/package.nix`
2. flip `source = 'mason' → 'nix'` in `lua/core/tools.lua`
3. `rebuild`, then in nvim: `:MasonUninstall <name>` and `:DotvimDoctor`

## NixOS note

mason's prebuilt binaries need a standard dynamic linker; on NixOS hosts set
`programs.nix-ld.enable = true;` at the system level. macOS and FHS Linux (e.g.
Oracle Linux) need nothing extra — mason works natively.

## References

- [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) — original base, since heavily personalized
- [neovim-kickstart-config](https://github.com/hendrikmi/neovim-kickstart-config)
