# Builds a wrapped neovim *runtime*:
#   - the neovim binary
#   - Tier-1 system tools on PATH (LSP servers, formatters, tree-sitter CLI, …)
#
# This package is deliberately CONFIG-AGNOSTIC. The config lives as a live git
# checkout at ~/.config/nvim2026 (NVIM_APPNAME=nvim2026), which you edit freely;
# lazy.nvim manages plugins (lazy-lock.json) and mason manages Tier-2 dynamic
# tools. Nix owns only the runtime, so `nix run .#nvim` on a fresh box gives you
# nvim + tools, and your config is whatever you've cloned to ~/.config/nvim2026.
{ pkgs
, lib ? pkgs.lib
  # rust-analyzer, injected by the flake from fenix (toolchain-matched nightly).
  # Falls back to nixpkgs' copy for standalone `callPackage` callers.
, rust-analyzer ? pkgs.rust-analyzer
}:

let
  # ── Tier-1 tools: always needed, pinned, on PATH inside *and* outside nvim ──
  # Kept lean on purpose: LSP servers/formatters stay in mason (Tier-2) and get
  # promoted here deliberately, one at a time. Promote a mason tool when it's
  # stable + in nixpkgs: add it below, drop it from mason `ensure_installed` in
  # lua/plugins/lsp.lua, then `:MasonUninstall <tool>` so the nix copy wins on
  # PATH. See README for the full checklist.
  runtimeDeps = with pkgs; [
    # Always needed, and NOT mason's job:
    ripgrep        # telescope/snacks live_grep
    fd             # telescope find_files
    git            # lazy.nvim bootstrap + plugin fetch

    # nvim-treesitter `main` branch compiles parsers at runtime:
    tree-sitter    # the CLI invoked by ts.install()
    gcc            # C compiler parser builds need (drop if you rely on system cc)

    # Runtime many mason-installed (node-based) LSP servers need on PATH:
    nodejs_22

    # Python 3.13 for mason's python-based tools (pylsp, codespell). Pins the
    # interpreter mason builds venvs against — otherwise it falls back to system
    # python3 (3.9). Provides python3/python on PATH.
    python313

    # ── Python dev toolchain (promoted out of mason; see PATH note below) ──────
    uv             # package/venv manager + python installer
    ruff           # linter + formatter (also an LSP)
    poethepoet     # `poe` task runner
    pyrefly        # type checker (Meta)
    # Type-check report tools — run on demand, but pinned so reports are stable:
    mypy
    basedpyright   # also an LSP; mason copy must be evicted (see note)
    ty             # Astral's type checker (early/0.0.x)

    # Rust: toolchain-matched rust-analyzer from fenix (see flake input). Pairs
    # with rustaceanvim (skip_autoconfigure) in lua/plugins/lsp.lua. Evict the
    # mason copy: `:MasonUninstall rust-analyzer` + drop from ensure_installed.
    rust-analyzer

    # ── none-ls formatters/linters (promoted out of mason) ─────────────────────
    # Used by lua/plugins/none-ls.lua sources; marked source='nix' in the
    # registry (lua/tools.lua) so mason-null-ls won't reinstall/shadow them.
    codespell      # spelling
    prettier       # html/json/yaml/markdown formatter
    shellcheck     # shell linter
    shfmt          # shell formatter
  ];

  # IMPORTANT — finish promoting ruff + basedpyright out of mason:
  # both are now pinned above, but mason.nvim prepends its own bin/ to PATH inside
  # nvim, so a stale mason copy will SHADOW the nix one. In nvim run:
  #   :MasonUninstall ruff basedpyright
  # and drop them from `ensure_installed` in lua/plugins/lsp.lua. Verify with
  # :LspInfo / :checkhealth that they resolve to /nix/store/...
  #
  # Still managed by mason (promotion candidates):
  #   lsp:     bashls, pylsp, jsonls, yamlls, lua_ls  (lua/plugins/lsp.lua)
  #   none-ls: stylua, checkmake                      (lua/plugins/none-ls.lua)
  # (clangd is system-provided via skip_autoinstall.)
  # nixpkgs attrs when you're ready to promote any of them:
  #   lua_ls -> lua-language-server   stylua -> stylua   checkmake -> checkmake
  #   bashls -> bash-language-server  jsonls/yamlls -> vscode-langservers-extracted / yaml-language-server
  #   (editing nix? add `nil` or `nixd` here + a server entry in lsp.lua)

in
# Wrap neovim-unwrapped directly (NOT pkgs.neovim). The pkgs.neovim wrapper
# generates its own init and launches with `-u <generated>`, which suppresses
# auto-sourcing of ~/.config/nvim2026/init.lua — you'd get a vanilla editor.
# neovim-unwrapped has no such injection, so it loads the config normally.
pkgs.symlinkJoin {
  name = "nvim";
  paths = [ pkgs.neovim-unwrapped ];
  buildInputs = [ pkgs.makeWrapper ];
  postBuild = ''
    wrapProgram $out/bin/nvim \
      --prefix PATH : ${lib.makeBinPath runtimeDeps} \
      --set-default NVIM_APPNAME nvim2026
  '';
  meta.mainProgram = "nvim";

  # Exposed so consumers can put the SAME pinned Tier-1 tools on the interactive
  # shell PATH (not just nvim's internal PATH). The hm-module and the flake's
  # `tools` package both read this — single source of truth.
  #   nix-repl> (callPackage ./nix/package.nix {}).runtimeDeps
  passthru.runtimeDeps = runtimeDeps;
}
