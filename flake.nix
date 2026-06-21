{
  description = "Neovim configuration — standalone flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      systems = [ "aarch64-darwin" "x86_64-darwin" "x86_64-linux" "aarch64-linux" ];

      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f {
        pkgs = nixpkgs.legacyPackages.${system};
        inherit system;
      });
    in {
      # ── Packages ───────────────────────────────────────────────────────────
      # `nix run github:tsaeger/dotvim#nvim` or `nix build .#nvim`
      packages = forAllSystems ({ pkgs, system }: {
        nvim = pkgs.callPackage ./nix/package.nix { };
        default = self.packages.${system}.nvim;
      });

      # ── Home-manager module ────────────────────────────────────────────────
      # In another flake:
      #   inputs.dotvim.url = "github:tsaeger/dotvim/nvim2026";
      #   imports = [ inputs.dotvim.homeManagerModules.default ];
      homeManagerModules.default = import ./nix/hm-module.nix self;

      # ── Dev shell ─────────────────────────────────────────────────────────
      devShells = forAllSystems ({ pkgs, ... }: {
        default = pkgs.mkShell {
          buildInputs = [ self.packages.${pkgs.system}.nvim ];
          shellHook = "echo 'nvim is ready'";
        };
      });
    };
}
