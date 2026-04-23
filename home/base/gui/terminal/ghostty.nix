{
  lib,
  pkgs,
  ...
}: let
  ghosttyPackage =
    if pkgs.stdenv.isDarwin
    then pkgs.ghostty-bin
    else pkgs.ghostty;

  commonSettings = {
    theme = "TokyoNight Storm";
    background-opacity = 0.75;

    palette = [
      "8=#9aa5ce"
    ];

    font-family = "Maple Mono NF CN";
    cursor-style-blink = false;
    cursor-invert-fg-bg = true;
    mouse-hide-while-typing = true;

    window-title-font-family = "Maple Mono NF CN";
    window-padding-balance = true;
    window-save-state = "always";

    auto-update = "download";

    shell-integration-features = true;
    copy-on-select = "clipboard";
    focus-follows-mouse = true;

    keybind = [
      "super+r=reload_config"
      "super+i=inspector:toggle"
      "super+f=toggle_fullscreen"
      "super+left=previous_tab"
      "super+right=next_tab"
      "super+b>x=close_surface"
      "super+b>c=new_tab"
      "super+b>n=new_window"
      "super+b>f=toggle_fullscreen"
      "super+b>1=goto_tab:1"
      "super+b>2=goto_tab:2"
      "super+b>3=goto_tab:3"
      "super+b>4=goto_tab:4"
      "super+b>5=goto_tab:5"
      "super+b>6=goto_tab:6"
      "super+b>7=goto_tab:7"
      "super+b>8=goto_tab:8"
      "super+b>9=goto_tab:9"
      "super+b>\\=new_split:right"
      "super+b>-=new_split:down"
      "super+b>e=equalize_splits"
      "super+b>z=toggle_split_zoom"
      "super+b>h=goto_split:left"
      "super+b>j=goto_split:bottom"
      "super+b>k=goto_split:top"
      "super+b>l=goto_split:right"
      "super+b>left=goto_split:left"
      "super+b>down=goto_split:bottom"
      "super+b>up=goto_split:top"
      "super+b>right=goto_split:right"
      "shift+enter=text:\\x1b\\r"
    ];
  };
in {
  catppuccin.ghostty.enable = false;

  programs.ghostty = {
    enable = true;
    package = ghosttyPackage;
    enableZshIntegration = true;
    enableBashIntegration = true;
    installBatSyntax = true;
    installVimSyntax = !pkgs.stdenv.isDarwin;
    settings =
      commonSettings
      // lib.optionalAttrs (!pkgs.stdenv.isDarwin) {
        font-size = 12;
      }
      // lib.optionalAttrs pkgs.stdenv.isDarwin {
        background-blur-radius = 40;
        macos-titlebar-style = "tabs";
        macos-option-as-alt = true;
        command = "${pkgs.zsh}/bin/zsh --login -c 'exec nu --login --interactive'";
        keybind = commonSettings.keybind ++ [
          "global:super+grave_accent=toggle_quick_terminal"
        ];
      };
  };
}
