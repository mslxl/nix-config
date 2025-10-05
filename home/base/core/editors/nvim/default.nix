{pkgs, ...}: {
  home.packages = with pkgs; [
    tree-sitter
  ];
  programs = {
    neovim = {
      enable = true;

      viAlias = true;
      vimAlias = true;
    };
  };
}
