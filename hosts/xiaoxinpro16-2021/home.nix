{pkgs, pkgs-stable, ...}: {
  home.packages = with pkgs-stable.jetbrains;
    [
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
      zathura
      steam
      geogebra6
      appimage-run
    ]);
}
