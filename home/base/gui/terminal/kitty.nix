{
  lib,
  pkgs,
  ...
}:
###########################################################
#
# Kitty Configuration
#
# Useful Hot Keys for Linux(replace `ctrl + shift` with `cmd` on macOS)):
#   1. Increase Font Size: `ctrl + shift + =` | `ctrl + shift + +`
#   2. Decrease Font Size: `ctrl + shift + -` | `ctrl + shift + _`
#   3. And Other common shortcuts such as Copy, Paste, Cursor Move, etc.
#
###########################################################
{
  programs.kitty = {
    enable = true;
    font = {
      name = "Maple Mono NF CN";
      # use different font size on macOS
      size =
        if pkgs.stdenv.isDarwin
        then 18
        else 12;
    };

    # consistent with other terminal emulators
    keybindings = {
      "ctrl+shift+m" = "toggle_maximized";
      "ctrl+shift+f" = "show_scrollback"; # search in the current window
    };

    settings = {
      # do not show title bar & window title
      hide_window_decorations =
        if pkgs.stdenv.isDarwin
        then "no"
        else "titlebar-and-corners";
      macos_show_window_title_in = "none";

      background_opacity = "0.93";
      macos_option_as_alt = true; # Option key acts as Alt on macOS
      enable_audio_bell = false;
      tab_bar_edge = "top"; # tab bar on top
      window_padding_width = 8; # padding between window border and terminal content

      #  To resolve issues:
      #    1. https://github.com/ryan4yin/nix-config/issues/26
      #    2. https://github.com/ryan4yin/nix-config/issues/8
      #  Spawn a nushell in login mode via `bash`
      shell = "${pkgs.bash}/bin/bash --login -c 'nu --login --interactive'";
    };

    # macOS specific settings
    # darwinLaunchOptions = ["--start-as=maximized"];
  };
}
