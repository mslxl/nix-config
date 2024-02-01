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
    commitizen
  ];


  programs.git = {
    enable = true;
    lfs.enable = true;
    userName = username;
    userEmail = useremail;
    aliases = {
      st = "status";
      lg = "log --graph --decorate --oneline";
      cm = "!cz commit";
      lz = "!lazygit";
    };
  };
}
