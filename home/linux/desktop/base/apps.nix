{
  pkgs,
  nur-pkgs,
  mylib,
  ...
}: {
  xdg.mimeApps.defaultApplications = (
    mylib.attrs.listToAttrs [
      "application/zip"
      "application/rar"
    ] (_: ["xarchiver.desktop"])
  );

  home.packages =
    (with pkgs; [
      zenity
      trash-cli
      bat
      xarchiver

      calibre
      anki
      remnote
      zotero
    ])
    ++ [
      (pkgs.callPackage ../../../../pkgs/dida365.nix {})
    ]
    ++ (with nur-pkgs.repos; [
      # xddxdd.wine-wechat

      # linyinfeng.wemeet
    ]);
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
