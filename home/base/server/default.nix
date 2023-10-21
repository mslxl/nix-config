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

  home.packages = with pkgs;[
    trash-cli
  ];

  programs.direnv.enable = true;
}
