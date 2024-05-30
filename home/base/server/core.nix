{pkgs, system, ...}: {
  home.packages = with pkgs; [
    pfetch
    bottom
    difftastic
    yazi
  ];
}
