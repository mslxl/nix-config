{
  pkgs,
  system,
  ...
}: {
  home.packages = with pkgs; [
    bottom
    difftastic
    yazi
  ];
}
