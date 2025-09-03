{
  lib,
  config,
  pkgs,
  ...
}: {
  home.activation.installAstroNvim = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if [ ! -d ${config.xdg.configHome}/nvim ]; then
      mkdir -p ${config.xdg.configHome}/nvim
    fi

    ${pkgs.rsync}/bin/rsync -avz --chmod=D2755,F744 ${./nvim}/ ${config.xdg.configHome}/nvim/
  '';

  xdg.mimeApps = {
    defaultApplications = {
      "text/plain" = ["neovide.desktop"];
    };
  };

  catppuccin.nvim.enable = false;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    withNodeJs = true;
    withPython3 = true;
    withRuby = true;

    extraLuaPackages = luaPkgs:
      with luaPkgs; [
        luautf8
      ];
    extraPackages = with pkgs; [
      ripgrep
      fd
      git
      lazygit

      gcc
      cmake
      gnumake

      gnutar
      curl
    ];
  };
}
