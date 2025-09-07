{
  pkgs,
  nur-pkgs,
  myutils,
  ...
}: {
  xdg.mimeApps.defaultApplications = (
    myutils.attrs.listToAttrs [
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
    ])
    ++ [
      (pkgs.callPackage ../../../../pkgs/dida365.nix {})
    ]
    ++ (with nur-pkgs.repos; [
      # xddxdd.wine-wechat

      # linyinfeng.wemeet
    ]);
}
