{
  pkgs,
  nur-pkgs-mslxl,
  nur-pkgs,
  ...
}: {
  home.packages =
    (with pkgs; [
      trash-cli
      bat
      xarchiver
    ])
    ++ (with nur-pkgs-mslxl; [
      dida365
    ])
    ++ (with nur-pkgs.repos; [
      # xddxdd.wechat-uos
      xddxdd.bilibili
      # linyinfeng.wemeet
    ]);
}
