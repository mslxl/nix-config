{
  pkgs,
  config,
  lib,
  ...
}: {
  config = {
    fonts.packages = with pkgs; [
      # microsoft fonts for school work
      corefonts
      vistafonts

      # icons & emoji
      material-design-icons
      font-awesome
      font-awesome_5
      noto-fonts-emoji

      # 霞鹜文楷 屏幕阅读版
      # https://github.com/lxgw/LxgwWenKai-Screen
      lxgw-wenkai-screen

      # Maple Mono NF CN (连字 未微调版，适用于高分辨率屏幕)
      # Full version, embed with nerdfonts icons, Chinese and Japanese glyphs
      # https://github.com/subframe7536/maple-font
      maple-mono.NF-CN-unhinted

      fira
      jetbrains-mono
      source-sans
      source-serif
      source-han-sans
      source-han-serif
      liberation_ttf_v2

      nerd-fonts.symbols-only
      nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono
      nerd-fonts.iosevka
    ];
  };
}
