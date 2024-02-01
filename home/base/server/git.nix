{
  config,
  lib,
  pkgs,
  username,
  useremail,
  ...
}: {
  home.packages = with pkgs; [
    lazygit
  ];


  programs.git = {
    enable = true;
    lfs.enable = true;
    userName = username;
    userEmail = useremail;
  };
}
