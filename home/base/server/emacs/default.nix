{
  lib,
  config,
  pkgs,
  doomemacs,
  ...
}:
with lib; let
  shellAliases = {
    e = "emacsclient --create-frame";
  };
in {
  home.packages = with pkgs; [
    # doom dependencies
    git
    (ripgrep.override {withPCRE2 = true;})
    gnutls

    fd
    zstd
    (aspellWithDicts (ds: with ds; [en en-computers en-science]))
    sqlite
    gcc
    cmake
    libtool
    gnumake
  ];

  programs.emacs = {
    enable = true;
    package = pkgs.emacs-nox;
  };

  home.sessionPath = ["$HOME/.config/emacs/bin"];
  home.shellAliases = shellAliases;

  xdg.configFile."doom" = {
    source = ./doom;
    force = true;
  };

  home.activation.installDoomEmacs = lib.hm.dag.entryAfter ["writeBoundary"] ''
    ${pkgs.rsync}/bin/rsync -avz --chmod=D2755,F744 ${doomemacs}/ ${config.xdg.configHome}/emacs/
  '';

  programs.git.aliases = {
    ma = "!emacs -nw --eval \"(magit-status)\"";
  };
}
