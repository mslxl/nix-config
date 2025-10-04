{
  mylib,
  pkgs,
  lib,
  config,
  ...
} @ args:
with lib; {
  config = mkIf (config.modules.desktop.type == "plasma") {
    home.file.".wayland-session" = {
      text = ''
        #!/usr/bin/env bash
        startplasma-wayland
      '';
      executable = true;
    };

    programs.plasma = {
      startup.startupScript = {
        # TODO
        # ${
        #   lib.concatStringsSep "\n"
        #   (builtins.map (prog: "exec-once = ") config.modules.desktop.exec.once)
        # }
        # ${
        #   lib.concatStringsSep "\n"
        #   (builtins.map (prog: "exec = ") config.modules.desktop.exec.always)
        # }
      };
      workspace.wallpaper = config.modules.desktop.background.source;
    };
  };
}
