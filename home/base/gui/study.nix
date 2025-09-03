{
  pkgs,
  pkgs-stable,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    # obsidian
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
    calibre
    anki
  ];
  # programs.anki = {
  #   enable = true;
  #   theme = "dark";
  #   style = "anki";
  #   sync = {
  #     url = "https://anki.mslxl.com";
  #     username = "mslxl";
  #     autoSync = true;
  #     syncMedia = true;
  #     autoSyncMediaMinutes = 5;
  #   };
  #   addons = [
  #     (pkgs.anki-utils.buildAnkiAddon (finalAttrs: {
  #       pname = "AJT Card Management";
  #       version = "2025-04-12";
  #       src = pkgs.fetchFromGitHub {
  #         owner = "Ajatt-Tools";
  #         repo = "learn-now-button";
  #         rev = "29de2b9b50ab5531898e72aa2b8b2144e8f43fe9";
  #         hash = "sha256-NQvcODTgkCDkN3GLAeRkYXTvDWjVgFdvnZ0MeKXPAPM=";
  #         fetchSubmodules = true;
  #         forceFetchGit = true;
  #       };
  #     }))
  #     pkgs.ankiAddons.anki-connect
  #     pkgs.ankiAddons.review-heatmap
  #   ];
  # };
}
