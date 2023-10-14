{ config, pkgs,  ... }:
{
  programs.vscode = {
    enable = true;
    # package = pkgs.vscode.fhs;
    # extensions = with nix-vscode-extensions; [
       # vscodevim.vim
    # ];
  };
}
