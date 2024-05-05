{pkgs, ...}: {
  home.packages = with pkgs; [
    alacritty
    alacritty-theme
  ];
}
