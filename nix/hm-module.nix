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
in {
  options.programs.dotvim = {
    enable = lib.mkEnableOption "dotvim neovim runtime (binary + Tier-1 tools)";

    package = lib.mkOption {
      type = lib.types.package;
      default = self.packages.${pkgs.system}.nvim;
      description = "The wrapped neovim runtime package to install.";
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
    home.packages = [ cfg.package ];

    home.activation = lib.mkIf cfg.bootstrapConfig {
      dotvimClone = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        cfgdir="${config.xdg.configHome}/nvim2026"
        if [ ! -e "$cfgdir" ]; then
          $DRY_RUN_CMD ${pkgs.git}/bin/git clone \
            --branch ${lib.escapeShellArg cfg.configBranch} \
            ${lib.escapeShellArg cfg.configRepo} "$cfgdir"
        fi
      '';
    };
  };
}
