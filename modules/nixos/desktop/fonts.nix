{pkgs, ...}: {
  # all fonts are linked to /nix/var/nix/profiles/system/sw/share/X11/fonts
  fonts = {
    enableDefaultPackages = false;
    fontDir.enable = true;

    packages = with pkgs; [
      # microsoft fonts for school work
      corefonts
      vistafonts

      # icons & emoji
      material-design-icons
      font-awesome
      font-awesome_5
      noto-fonts-emoji

      fira
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

    fontconfig.defaultFonts = {
      serif = ["Source Han Serif SC" "Source Han Serif TC" "Noto Color Emoji"];
      sansSerif = ["Source Han Sans SC" "Source Han Sans TC" "Noto Color Emoji"];
      monospace = ["JetBrainsMono Nerd Font" "Noto Color Emoji"];
      emoji = ["Noto Color Emoji"];
    };
  };

  # services.kmscon = {
  #   enable = true;
  #   fonts = [
  #     {
  #       name = "Source Code Pro";
  #       package = pkgs.source-code-pro;
  #     }
  #   ];
  #   extraOptions = "--term xterm-256color";
  #   extraConfig = "font-size=18";
  #   hwRender = true;
  # };
}
