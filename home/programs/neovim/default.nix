{ config, pkgs, ... }:

{
  programs = {
    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      withPython3 = true;
      withNodeJs = true;
      extraPackages = [
      ];
      plugins = with pkgs.vimPlugins;[ ];
    };
  };

  home.file.".config/nvim" = {
    source = ./nvim;
    recursive = true;
    executable = false;
  };
}
