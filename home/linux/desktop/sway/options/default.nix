{
  pkgs,
  config,
  lib,
  ...
} @ args:
with lib; {
  options.modules.desktop.sway.extraConfig = mkOption {
    default = "";
    type = types.str;
    description = ''
      Host related config
    '';
  };

  config = mkIf (config.modules.desktop.type == "sway") {
    xdg.configFile."sway/script/".source = ./script;
    home.packages = with pkgs; [
      flameshot
      cliphist
    ];
    home.file.".wayland-session" = {
      source = "${pkgs.sway}/bin/sway";
      executable = true;
    };
    wayland.windowManager.sway = {
      enable = true;
      package = pkgs.sway;
      extraConfig = ''
        input type:touchpad {
        dwt enabled
        tap enabled
        natural_scroll enabled
        middle_emulation enabled
        }
        input type:keyboard xkb_numlock enabled
        ${config.modules.desktop.sway.extraConfig}
      '';
      config =
        {
          modifier = "Mod4";
          startup = [
            {command = "${pkgs.networkmanagerapplet}/bin/nm-applet";}
            {command = "fcitx5 -d --replace";}
            {command = "dunst";}
            {
              command = "${pkgs.swaybg}/bin/swaybg -m fill -i ${config.modules.desktop.background.source}";
              always = true;
            }
            {
              command = "foot -s";
              always = true;
            }
            {
              command = ''                exec swayidle -w \
                          timeout 300 'swaylock -f -c 000000' \
                          timeout 600 'swaymsg "output * power off"' resume 'swaymsg "output * power on"' \
                          before-sleep 'swaylock -f -c 000000' '';
            }
          ];
          terminal = "${pkgs.foot}/bin/foot";
          up = "k";
          down = "j";
          left = "h";
          right = "l";
          modes = {
            split = {
              "s" = "splith; mode \"default\"";
              "v" = "splitv; mode \"default\"";
              "Return" = "mode \"default\"";
              "Escape" = "mode \"default\"";
            };
            passthru = {
              "Escape" = "mode \"default\"";
            };
          };
          keybindings = let
            modifier = config.wayland.windowManager.sway.config.modifier;
          in ({
              "${modifier}+Return" = "exec ${pkgs.foot}/bin/footclient";
              "${modifier}+Shift+c" = "kill";
              "${modifier}+Ctrl+Return" = "exec rofi -show drun";
              "${modifier}+Ctrl+q" = "exec wlogout";
              "${modifier}+p" = "mode passthru";
              "${modifier}+e" = "exec foot yazi";
              "${modifier}+v" = "exec ~/.config/sway/script/cliphist.sh";
              "${modifier}+PRINT" = "exec flameshot gui";
            }
            // {
              "${modifier}+grave" = "scratchpad show";
              "${modifier}+Shift+grave" = "move scratchpad";
            }
            // {
              # layout
              "${modifier}+r" = "mode split";
              "${modifier}+f" = "fullscreen";
              "${modifier}+space" = "floating toggle";

              "${modifier}+${config.wayland.windowManager.sway.config.up}" = "focus up";
              "${modifier}+${config.wayland.windowManager.sway.config.down}" = "focus down";
              "${modifier}+${config.wayland.windowManager.sway.config.left}" = "focus left";
              "${modifier}+${config.wayland.windowManager.sway.config.right}" = "focus right";
              "${modifier}+Shift+${config.wayland.windowManager.sway.config.up}" = "resize shrink height 10px";
              "${modifier}+Shift+${config.wayland.windowManager.sway.config.down}" = "resize grow height 10px";
              "${modifier}+Shift+${config.wayland.windowManager.sway.config.left}" = "resize shrink width 10px";
              "${modifier}+Shift+${config.wayland.windowManager.sway.config.right}" = "resize grow width 10px";
            }
            // {
              # fn key
              "XF86MonBrightnessUp" = "exec brightnessctl -q s +10%";
              "XF86MonBrightnessDown" = "exec brightnessctl -q s 10%-";
              "XF86AudioRaiseVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ +5%";
              "XF86AudioLowerVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ -5%";
              "XF86AudioMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
              "XF86AudioPlay" = "exec playerctl play-pause";
              "XF86AudioPause" = "exec playerctl pause";
              "XF86AudioNext" = "exec playerctl next";
              "XF86AudioPrev" = "exec playerctl previous";
              "XF86AudioMicMute" = "exec pactl set-source-mute @DEFAULT_SOURCE@ toggle";
              "XF86Calculator" = "exec qalculate-gtk";
            }
            // {
              # workspace
              "${modifier}+1" = "workspace number 1";
              "${modifier}+2" = "workspace number 2";
              "${modifier}+3" = "workspace number 3";
              "${modifier}+4" = "workspace number 4";
              "${modifier}+5" = "workspace number 5";
              "${modifier}+6" = "workspace number 6";
              "${modifier}+7" = "workspace number 7";
              "${modifier}+8" = "workspace number 8";
              "${modifier}+9" = "workspace number 9";
              "${modifier}+0" = "workspace number 10";
              "${modifier}+Shift+1" = "move container to workspace number 1";
              "${modifier}+Shift+2" = "move container to workspace number 2";
              "${modifier}+Shift+3" = "move container to workspace number 3";
              "${modifier}+Shift+4" = "move container to workspace number 4";
              "${modifier}+Shift+5" = "move container to workspace number 5";
              "${modifier}+Shift+6" = "move container to workspace number 6";
              "${modifier}+Shift+7" = "move container to workspace number 7";
              "${modifier}+Shift+8" = "move container to workspace number 8";
              "${modifier}+Shift+9" = "move container to workspace number 9";
              "${modifier}+Shift+0" = "move container to workspace number 10";
              "${modifier}+Tab" = "workspace back_and_forth";
            });
          bars = [
            {
              command = "waybar";
              position = "top";
            }
          ];
        }
        // (import ./theme.nix args);
    };
  };
}
