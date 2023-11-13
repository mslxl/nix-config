{ config, pkgs, ... }:

{
  # Maybe use falke and direnv is a better choice?
  home.packages = with pkgs; [
    (prismlauncher.override { jdks = [ jdk8 jdk17 jdk adoptopenjdk-jre-openj9-bin-11 ]; })
  ];
}
