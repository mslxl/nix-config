{
  pkgs,
  wallpapers,
  ...
}: {
  modules.desktop = {
    wayland.enable = true;
    type = "niri";
  };

  nix.settings = {
    max-jobs = 12; # leave 4 CPU for other work, which would make computer available when rebuild
    cores = 12;
  };
}
