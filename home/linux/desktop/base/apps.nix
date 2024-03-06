{
  pkgs,
  nur-pkgs-mslxl,
  nur-pkgs,
  ...
}: {
  home.packages = with pkgs; [
    trash-cli
    bat
    wpsoffice
    cmus
  ]
  ++ (with nur-pkgs-mslxl; [
    dida365
    liteloader-qqnt
  ])
  ++ (with nur-pkgs.repos; [
	  xddxdd.wechat-uos
    xddxdd.bilibili
    linyinfeng.wemeet
  ]);
}
