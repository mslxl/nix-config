{pkgs, ...}: {
  home.packages = with pkgs; [
    pfetch
    neofetch
    yazi
    bottom
  ];
}
