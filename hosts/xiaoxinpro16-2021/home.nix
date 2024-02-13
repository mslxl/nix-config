{
  pkgs,
  ...
}: {
  home.packages = with pkgs.jetbrains; [
    webstorm
    rust-rover
    pycharm-professional
    mps
    idea-ultimate
    idea-community
    goland
    gateway
    datagrip
    clion
  ]
  ++ (with pkgs; [
    steam
    geogebra6
  ]);
}
