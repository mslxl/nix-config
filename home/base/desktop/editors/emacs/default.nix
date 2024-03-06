{
  lib,
  config,
  pkgs,
  doomemacs,
  ...
}:
with lib; let
  envExtra = ''
    export PATH="${config.xdg.configHome}/emacs/bin:$PATH"
  '';
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
    emacs
  ];

  programs.bash.bashrcExtra = envExtra;
  programs.zsh.envExtra = envExtra;
  home.shellAliases = shellAliases;

  xdg.configFile."doom" = {
    source = ./doom;
    force = true;
  };

  home.activation.installDoomEmacs = lib.hm.dag.entryAfter ["writeBoundary"] ''
    ${pkgs.rsync}/bin/rsync -avz --chmod=D2755,F744 ${doomemacs}/ ${config.xdg.configHome}/emacs/
  '';
  services.emacs.enable = true;

  programs.git.aliases = {
    ma = "!emacs -nw --eval \"(magit-status)\"";
  };
}
