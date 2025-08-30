{
  pkgs,
  nur-pkgs-mslxl,
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
      wechat-uos
    ])
    ++ (with nur-pkgs-mslxl; [
      dida365
    ])
    ++ (with nur-pkgs.repos; [
      # xddxdd.wine-wechat

      # linyinfeng.wemeet
    ]);
}
