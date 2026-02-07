{
  pkgs,
  lib,
  config,
  ...
}: {
  options.modules.writing.enable = lib.mkEnableOption "Enable writing module";

  config = lib.mkIf config.modules.writing.enable {
    home.packages = with pkgs; [
      texlive.combined.scheme-full
      typst
    ];
  };
}
