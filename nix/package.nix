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
  ];

  # Promotion candidates — currently managed by mason in lua/plugins/lsp.lua:
  #   bashls, basedpyright, ruff, pylsp, jsonls, yamlls, lua_ls, rust_analyzer, stylua
  # (clangd is system-provided via skip_autoinstall.)
  # nixpkgs attrs when you're ready to promote any of them:
  #   lua_ls -> lua-language-server   stylua -> stylua   ruff -> ruff
  #   bashls -> nodePackages.bash-language-server        jsonls/yamlls -> nodePackages.vscode-langservers-extracted / yaml-language-server
  #   basedpyright -> basedpyright    rust_analyzer -> rust-analyzer
  #   (editing nix? add `nil` or `nixd` here + a server entry in lsp.lua)

  wrappedNeovim = pkgs.neovim.override {
    configure = {
      # Empty customRC — all real config comes from ~/.config/nvim2026
      customRC = "";
    };
  };
in
pkgs.symlinkJoin {
  name = "nvim";
  paths = [ wrappedNeovim ];
  buildInputs = [ pkgs.makeWrapper ];
  postBuild = ''
    wrapProgram $out/bin/nvim \
      --prefix PATH : ${lib.makeBinPath runtimeDeps} \
      --set-default NVIM_APPNAME nvim2026
  '';
  meta.mainProgram = "nvim";
}
