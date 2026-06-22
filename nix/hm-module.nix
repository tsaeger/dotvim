# Home-manager module exposed by the dotvim flake.
# Usage in another system flake (nix-darwin, NixOS, or standalone home-manager):
#
#   inputs.dotvim = {
#     url = "github:tsaeger/dotvim/nvim2026";
#     # optional: keep nixpkgs in sync with the host flake
#     # inputs.nixpkgs.follows = "nixpkgs";
#   };
#
#   imports = [ inputs.dotvim.homeManagerModules.default ];
#   programs.dotvim.enable = true;
#
# This module installs ONLY the runtime (nvim binary + Tier-1 tools). The config
# is a LIVE GIT CHECKOUT at ~/.config/nvim2026 that you clone and edit yourself
# — it is intentionally NOT managed/symlinked by Nix, so you can evolve it freely
# and let lazy.nvim update plugins. Set `bootstrapConfig = true` to have the
# module git-clone the repo on first activation if the directory is absent
# (it never touches an existing checkout).
#
# NixOS hosts only: mason's prebuilt binaries need a standard dynamic linker, so
# add `programs.nix-ld.enable = true;` at the SYSTEM level. macOS and FHS Linux
# (e.g. Oracle Linux) need nothing extra — mason works natively there.
self: { pkgs, lib, config, ... }:

let
  cfg = config.programs.dotvim;
  # A single directory bundling all Tier-1 tools (one bin/). Same derivations the
  # nvim wrapper injects, so anything resolved via $DOTVIM_TOOLS_BIN matches what
  # nvim sees internally.
  toolsEnv = pkgs.buildEnv {
    name = "nvim-tools";
    paths = cfg.package.runtimeDeps;
  };
in {
  options.programs.dotvim = {
    enable = lib.mkEnableOption "dotvim neovim runtime (binary + Tier-1 tools)";

    package = lib.mkOption {
      type = lib.types.package;
      default = self.packages.${pkgs.system}.nvim;
      description = "The wrapped neovim runtime package to install.";
    };

    toolsPath = lib.mkOption {
      type = lib.types.enum [ "profile" "var" "none" ];
      default = "var";
      description = ''
        How to expose the Tier-1 tools (ripgrep, fd, tree-sitter, node, python, …)
        to your *interactive shell*, beyond nvim's internal PATH. They're bundled
        into a single directory (one `bin/`) regardless — same pinned versions the
        nvim wrapper injects.

        - "var"     : set $DOTVIM_TOOLS_BIN to that bin/ dir but DON'T touch PATH.
                      You add it yourself, choosing the order, e.g. in zshrc:
                          export PATH="$DOTVIM_TOOLS_BIN:$PATH"   # prefix (wins)
                          export PATH="$PATH:$DOTVIM_TOOLS_BIN"   # suffix (fallback)
        - "profile" : prepend the tools to your home-manager profile PATH (no
                      manual step, but you don't control ordering vs other pkgs).
        - "none"    : keep the tools scoped to nvim only.
      '';
    };

    neovide = {
      enable = lib.mkEnableOption ''
        the Neovide GUI, wired to the same wrapped nvim runtime (terminal `nvim`
        and `neovide` then share NVIM_APPNAME=nvim2026 + Tier-1 tools). On macOS
        this also installs Neovide.app (home-manager links it into
        ~/Applications/Home Manager Apps for Spotlight/Dock)'';

      package = lib.mkOption {
        type = lib.types.package;
        default = self.packages.${pkgs.system}.neovide;
        description = "The Neovide package (defaults to the dotvim-wired build).";
      };

      fontPackage = lib.mkOption {
        type = lib.types.package;
        default = pkgs.nerd-fonts.meslo-lg;
        description = ''
          Nerd Font package installed and (on macOS) linked into ~/Library/Fonts
          so the GUI can find it. Defaults to Meslo LG Nerd Font.
        '';
      };

      font = lib.mkOption {
        type = lib.types.str;
        default = "MesloLGM Nerd Font";
        description = "Font family Neovide uses (must be provided by fontPackage).";
      };

      fontSize = lib.mkOption {
        type = lib.types.number;
        default = 14.0;
        description = "Neovide font size (points).";
      };

      manageConfig = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Write ~/.config/neovide/config.toml setting the font above. Disable to
          manage that file yourself.
        '';
      };
    };

    bootstrapConfig = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        If true, clone the config to ~/.config/nvim2026 on activation when that
        directory does not already exist. Existing checkouts are left untouched.
        Useful for ephemeral boxes; leave false on machines where you manage the
        checkout by hand.
      '';
    };

    configRepo = lib.mkOption {
      type = lib.types.str;
      default = "https://github.com/tsaeger/dotvim.git";
      description = "Git URL cloned when bootstrapConfig is enabled.";
    };

    configBranch = lib.mkOption {
      type = lib.types.str;
      default = "nvim2026";
      description = "Branch checked out when bootstrapConfig is enabled.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ]
      ++ lib.optional (cfg.toolsPath == "profile") toolsEnv
      ++ lib.optionals cfg.neovide.enable [ cfg.neovide.package cfg.neovide.fontPackage ];

    # Neovide reads ~/.config/neovide/config.toml; point it at the Nerd Font.
    xdg.configFile."neovide/config.toml" =
      lib.mkIf (cfg.neovide.enable && cfg.neovide.manageConfig) {
        text = ''
          # Managed by the dotvim flake (programs.dotvim.neovide).
          [font]
          normal = [ "${cfg.neovide.font}" ]
          size = ${toString cfg.neovide.fontSize}
        '';
      };

    # macOS GUI apps discover fonts from ~/Library/Fonts (not the Nix profile),
    # so symlink the Nerd Font's files there. Linux relies on fontconfig finding
    # them via home.packages, so this is darwin-only.
    home.activation.dotvimFonts =
      lib.mkIf (cfg.neovide.enable && pkgs.stdenv.hostPlatform.isDarwin)
        (lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          fontdir="$HOME/Library/Fonts"
          $DRY_RUN_CMD mkdir -p "$fontdir"
          # Clear links from a previous generation (namespaced by prefix), then
          # link each font file in directly — macOS registers files in ~/Library/
          # Fonts reliably (subfolder recursion is not guaranteed).
          $DRY_RUN_CMD find "$fontdir" -maxdepth 1 -name 'dotvim-*' -delete
          while IFS= read -r -d "" f; do
            $DRY_RUN_CMD ln -sf "$f" "$fontdir/dotvim-$(basename "$f")"
          done < <(find -L "${cfg.neovide.fontPackage}/share/fonts" \
                     \( -iname '*.ttf' -o -iname '*.otf' \) -print0)
        '');

    # "var" mode: hand you the bin/ dir, let you place it in PATH yourself.
    home.sessionVariables = lib.mkIf (cfg.toolsPath == "var") {
      DOTVIM_TOOLS_BIN = "${toolsEnv}/bin";
    };

    home.activation.dotvimClone = lib.mkIf cfg.bootstrapConfig (
      lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        cfgdir="${config.xdg.configHome}/nvim2026"
        if [ ! -e "$cfgdir" ]; then
          $DRY_RUN_CMD ${pkgs.git}/bin/git clone \
            --branch ${lib.escapeShellArg cfg.configBranch} \
            ${lib.escapeShellArg cfg.configRepo} "$cfgdir"
        fi
      ''
    );
  };
}
