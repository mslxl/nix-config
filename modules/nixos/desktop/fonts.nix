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
      noto-fonts-emoji

      source-sans
      source-serif
      source-han-sans
      source-han-serif

      (nerdfonts.override {
        fonts = [
          "NerdFontsSymbolsOnly"

          "FiraCode"
          "JetBrainsMono"
          "Iosevka"

        ];
      })
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
  #   extraConfig = "font-size=12";
  #   hwRender = true;
  # };
}
