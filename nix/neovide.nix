# Neovide GUI wired to the dotvim-wrapped neovim runtime.
#
# Bakes into neovide, for BOTH the terminal `neovide` and the macOS Neovide.app:
#   --neovim-bin <wrapped nvim>  so both launch the SAME runtime
#                                (NVIM_APPNAME=nvim2026 + Tier-1 tools on PATH);
#                                the GUI app doesn't inherit your shell $PATH.
#   --icon <custom png>          so the *runtime* Dock/cmd-Tab icon is ours.
#                                Neovide calls setApplicationIconImage: at launch
#                                from --icon (else an embedded default), which
#                                OVERRIDES the bundle's .icns — so setting the
#                                bundle icon alone leaves cmd-Tab showing stock.
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
    cp ${icon}/icon.icns $out/Applications/Neovide.app/Contents/Resources/Neovide.icns
    makeBinaryWrapper ${lib.getExe neovide} $out/bin/neovide \
      --add-flags "--neovim-bin ${neovimBin} --icon ${icon}/icon.png"
  ''
else
  # Linux: no .app bundle — just wrap the binary (--icon sets the taskbar icon).
  pkgs.symlinkJoin {
    name = "neovide-dotvim-${neovide.version or "0"}";
    inherit meta;
    paths = [ neovide ];
    nativeBuildInputs = [ pkgs.makeBinaryWrapper ];
    postBuild = ''
      wrapProgram $out/bin/neovide \
        --add-flags "--neovim-bin ${neovimBin} --icon ${icon}/icon.png"
    '';
  }
