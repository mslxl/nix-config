{myutils, pkgs, ...}:
{
  imports = myutils.scanPaths ./.;

  home.packages = with pkgs; [
    (vivaldi.override{
      proprietaryCodecs = true;
      enableWidevine = true;
    })

    typora
    trash-cli
  ];

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
      package = pkgs.papirus-icon-theme;
      name = "Papirus-Dark";
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
  };
}
