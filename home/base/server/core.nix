{
  pkgs,
  system,
  yazi,
  ...
}:
builtins.trace yazi {
  home.packages = with pkgs; [
    bottom
    difftastic
    yazi.packages.${system}.default
  ];
}
