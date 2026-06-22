# Builds Neovide icons from the official Neovim mark with a large, semi-
# transparent label ("2026") overlaid across it. Output is a directory with:
#   icon.icns  — for the macOS .app bundle (Finder/Quick Look/Spotlight)
#   icon.png   — for `neovide --icon`, which drives the *runtime* Dock/cmd-Tab
#                icon via setApplicationIconImage: (this overrides the bundle
#                icon, so the bundle .icns alone is not enough).
#
# Pure Nix — no `iconutil` (absent from the build sandbox). librsvg rasterizes
# the vector mark, imagemagick composites the overlay, libicns packs the .icns.
{ pkgs
, lib ? pkgs.lib
, label ? "2026"
}:

let
  # Official Neovim mark (the square "N"); pinned by content hash.
  mark = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/neovim/neovim.github.io/master/static/logos/neovim-mark.svg";
    hash = "sha256-TWPhtN6Z6TbdizyU1abOKx54knkAMOTi9H+Mz51W0no=";
  };
in
pkgs.runCommand "neovide-icon-${label}"
{
  nativeBuildInputs = [ pkgs.librsvg pkgs.imagemagick pkgs.libicns pkgs.dejavu_fonts ];
} ''
  mkdir -p $out

  # 1) Rasterize the mark and center it on a 1024² transparent canvas.
  rsvg-convert -h 760 ${mark} -o mark.png
  magick -size 1024x1024 xc:none mark.png -gravity center -composite base.png

  # 2) Overlay the label large and semi-transparent across the whole icon.
  magick base.png -gravity center \
    -font ${pkgs.dejavu_fonts}/share/fonts/truetype/DejaVuSans-Bold.ttf \
    -pointsize 340 \
    -stroke 'rgba(0,0,0,0.40)' -strokewidth 10 -fill 'rgba(255,255,255,0.55)' \
    -annotate 0 '${label}' \
    iconified.png

  # 3a) PNG for `neovide --icon` (runtime Dock/cmd-Tab/taskbar icon).
  magick iconified.png -resize 512x512 $out/icon.png

  # 3b) .icns for the macOS .app bundle. Only the PNG-stored icns types
  #     (128–1024, ic07–ic10) — the small RLE types (16/32/48) overflow libicns'
  #     encoder ("Output buffer space exceeded"); macOS downscales 128 for those.
  for s in 128 256 512 1024; do
    magick iconified.png -resize ''${s}x''${s} icon_''${s}.png
  done
  png2icns $out/icon.icns icon_128.png icon_256.png icon_512.png icon_1024.png
''
