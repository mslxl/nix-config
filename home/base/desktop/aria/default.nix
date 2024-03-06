{pkgs, ...}: {
  home.packages = with pkgs; [
    aria
    ariang
  ];
  # TODO: setup aria deamon
}
