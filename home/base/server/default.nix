{
  pkgs,
  config,
  ...
}: {
  imports = [
    ./shell
    ./neovim
    ./sdk
    ./git.nix
  ];

  programs.direnv.enable = true;
}
