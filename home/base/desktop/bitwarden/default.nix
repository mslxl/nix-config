{
  lib,
  config,
  pkgs,
  ...
}: {
    home.packages = with pkgs; [
      bitwarden

      bitwarden-cli
      bitwarden-menu
      ydotool
    ];
    # xdg.configFile."bwm/config.ini".text = ''
    #   [dmenu]
    #   # dmenu_command = rofi -dmenu -i
    #   dmenu_command = ${pkgs.dmenu}/bin/dmenu -b -i


    #   [dmenu_passphrase]
    #   obscure = True
    #   obscure_color = #303030

    #   [vault]
    #   gui_editor = ${pkgs.neovide}/bin/neovide
    #   server_1 = https://vault.bitwarden.com
    #   email_1 = i@mslxl.com
    #   twofactor_1 = 0
    #   password_cmd_1 = ${pkgs.coreutils}/bin/cat /home/mslxl/bwpass
    #   session_timeout_min = 720

    #   type_library = ydotool
    # '';
}
