{
  pkgs,
  lib,
  config,
  ...
}: with lib; let
  cfg = config.modules.desktop.hyprland;
in {
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      swww
    ];
    systemd.user.services.swww-change = {
      Unit = {
        Description = "swww";
        After = [ "graphical-session.target" "sww.unit" ];
        PartOf = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = "${pkgs.bash}/bin/sh -c '${pkgs.swww}/bin/swww img ${config.modules.desktop.background.source}'";
        ExecReload = "${pkgs.coreutils}/bin/kill -SIGUSR2 $MAINPID";
        Restart = "on-failure";
        KillMode = "mixed";
        PrivateTmp = true;
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}
