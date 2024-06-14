{
  lib,
  config,
  pkgs,
  ...
}: {
  home.activation.installAstroNvim = lib.hm.dag.entryAfter ["writeBoundary"] ''
    ${pkgs.rsync}/bin/rsync -avz --chmod=D2755,F744 ${./nvim}/ ${config.xdg.configHome}/nvim/
  '';

  xdg.mimeApps = {
    defaultApplications = {
      "text/plain" = ["neovide.desktop"];
    };
  };

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
