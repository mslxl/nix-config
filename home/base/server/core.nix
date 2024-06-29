{
  pkgs,
  system,
  yazi,
  ...
}: {
  home.packages = with pkgs; [
    bottom
    difftastic
  ];
}
