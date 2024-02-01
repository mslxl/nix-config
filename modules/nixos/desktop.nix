{
  hyprland,
  pkgs,
  system,
  ...
} : {
  imports = [
    ./desktop
  ];

  services.xserver = {
    enable = true;
    displayManager.sddm = {
      enable = true;
      # wayland.enable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    foot
    wofi
  ];

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
    ];
  };

  programs.hyprland = {
    enable = true;
    package = hyprland.packages.${system}.hyprland;
    xwayland.enable = true;
  };

}
