{
  myutils,
  pkgs,
  ...
}: {
  imports = myutils.scanPaths ./.;

  services.kdeconnect = {
    enable = true;
    indicator = true;
  };

  gtk = {
    enable = true;
    cursorTheme = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
    };
    iconTheme = {
      package = pkgs.papirus-icon-theme.overrideAttrs (super: {
        installPhase = pkgs.lib.concatStringsSep "\n" [
          ''find . -type f -name "firefox.png" -exec rm -f {} \;''
          ''find . -type f -name "firefox.svg" -exec rm -f {} \;''

          super.installPhase
        ];
      });
      name = "Papirus";
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = false;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = false;
    };
  };
}
