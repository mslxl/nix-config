{ config, pkgs, astronvim , ... }:

{
  imports = [
    ../sdk/python.nix
    ../sdk/nodejs.nix
  ];

  programs = {
    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      withPython3 = true;
      withNodeJs = true;
      extraPackages = [];
      plugins = with pkgs.vimPlugins;[ ];
    };
  };

  xdg.configFile = {
    # astronvim's config
    "nvim".source = astronvim;

    # my custom astronvim config, astronvim will load it after base config
    # https://github.com/AstroNvim/AstroNvim/blob/v3.32.0/lua/astronvim/bootstrap.lua#L15-L16
    "astronvim/lua/user".source = ./astronvim_user;
  };

}
