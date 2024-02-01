{
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    pfetch
    neofetch
  ];
}
