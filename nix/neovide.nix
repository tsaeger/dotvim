# Neovide GUI wired to the dotvim-wrapped neovim runtime.
#
# Bakes `--neovim-bin <wrapped nvim>` into neovide so BOTH entry points launch
# the SAME runtime (NVIM_APPNAME=nvim2026 + Tier-1 tools on PATH):
#   - the terminal `neovide` command, and
#   - the macOS Neovide.app (Dock/Spotlight) — which does NOT inherit your shell
#     $PATH, so without this it could not find the wrapped nvim.
#
# On Darwin we copy the .app bundle and drop a makeBinaryWrapper'd `neovide` in
# $out/bin; the bundle's `Contents/MacOS -> ../../../bin` symlink then resolves
# to that wrapper. makeBinaryWrapper (not the shell-script wrapper) is used so
# the bundle's executable stays a real Mach-O, which LaunchServices requires.
{ pkgs
, lib ? pkgs.lib
, neovide ? pkgs.neovide
, nvim                       # the dotvim-wrapped neovim (provides bin/nvim)
, iconLabel ? "2026"        # overlaid on the Neovim mark for Neovide.app (macOS)
}:

let
  neovimBin = lib.getExe nvim;
  meta = neovide.meta // { mainProgram = "neovide"; };
  icon = import ./icon.nix { inherit pkgs lib; label = iconLabel; };
in
if pkgs.stdenv.hostPlatform.isDarwin then
  pkgs.runCommand "neovide-dotvim-${neovide.version or "0"}"
    {
      inherit meta;
      nativeBuildInputs = [ pkgs.makeBinaryWrapper ];
    } ''
    mkdir -p $out/bin $out/Applications
    # Tiny copy: the bundle's MacOS dir is a symlink, so this is just plist+icons.
    cp -R ${neovide}/Applications/Neovide.app $out/Applications/
    chmod -R u+w $out/Applications/Neovide.app
    # Swap in the custom icon (plist's CFBundleIconFile is "Neovide.icns").
    cp ${icon} $out/Applications/Neovide.app/Contents/Resources/Neovide.icns
    makeBinaryWrapper ${lib.getExe neovide} $out/bin/neovide \
      --add-flags "--neovim-bin ${neovimBin}"
  ''
else
  # Linux: no .app bundle — just wrap the binary.
  pkgs.symlinkJoin {
    name = "neovide-dotvim-${neovide.version or "0"}";
    inherit meta;
    paths = [ neovide ];
    nativeBuildInputs = [ pkgs.makeBinaryWrapper ];
    postBuild = ''
      wrapProgram $out/bin/neovide --add-flags "--neovim-bin ${neovimBin}"
    '';
  }
