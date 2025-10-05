{
  pkgs,
  pkgs-stable,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    zotero
    (pkgs-stable.logseq.overrideAttrs (super: {
      buildInputs = (super.buildInputs or []) ++ [pkgs.makeWrapper];

      postFixup =
        super.postFixup
        or ""
        + ''
          wrapProgram "$out/bin/logseq" \
            --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--enable-wayland-ime --wayland-text-input-version=3}}" \
        '';
    }))
  ];
}
