{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    (python311.withPackages (ps:
      with ps; [
        virtualenv
        pandas
        requests
        pyquery
        pyyaml
        numpy
      ]
    ))
    yapf
  ];
}
