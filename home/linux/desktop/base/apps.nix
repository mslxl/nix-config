{
  pkgs,
  nur-pkgs-mslxl,
  ...
}: {
  home.packages = with pkgs; [
    trash-cli
    wpsoffice
    cmus
  ]
  ++ [
    nur-pkgs-mslxl.dida365
  ];
}
