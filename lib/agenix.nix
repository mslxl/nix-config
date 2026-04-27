{inputs, ...}: {
  nixosModules = [
    inputs.agenix.nixosModules.default
    ../secrets/agenix.nix
  ];

  darwinModules = [
    inputs.agenix.darwinModules.default
    ../secrets/agenix.nix
  ];

  homeManagerModules = [
    inputs.agenix.homeManagerModules.default
    ../secrets/home.nix
  ];
}
